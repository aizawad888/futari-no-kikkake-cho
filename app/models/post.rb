class Post < ApplicationRecord
  attr_accessor :reveal_offset_seconds

  belongs_to :user
  belongs_to :pair, optional: true
  belongs_to :category
  has_many :post_memos, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :notify_partner_of_new_post

  validates :title, presence: true
  validates :reveal_at, presence: true


  enum sense_level: {
    low: 0,
    medium: 1,
    high: 2
  }

  def sense_level_jp
    case sense_level
    when "low" then "低"
    when "medium" then "中"
    when "high" then "高"
    end
  end

  # select用に引数付きメソッド
  def self.sense_level_jp_for(key)
    case key
    when "low" then "低"
    when "medium" then "中"
    when "high" then "高"
    end
  end

  def title_for_view(viewer)
    if user == viewer
      title
    else
      Time.current < reveal_at ? category.hint_text : title
    end
  end

  def just_unlocked?(last_viewed_at)
    reveal_at.present? &&
      last_viewed_at.present? &&
      reveal_at > last_viewed_at &&
      reveal_at <= Time.current
  end

  # unlock_at が過ぎて初めて index を見たときだけ通知を作る
  def create_post_unlocked_notification!
    # ペアを取得
    pair = Pair.find_by("user_id1 = ? OR user_id2 = ?", user.id, user.id)
    return unless pair

    # 相手ユーザーを決定
    partner = pair.user1 == user ? pair.user2 : pair.user1
    return unless partner

    # すでに同じ通知がある場合は作らない
    return if notifications.exists?(notification_kind: "post_unlocked", user: partner)

    # 通知作成
    partner.notifications.create!(
      notification_kind: "post_unlocked",
      notifiable: self
    )
  end

  def reveal_offset_seconds
    return nil unless reveal_at && created_at
    (reveal_at - created_at).to_i
  end

  private

  def notify_partner_of_new_post
    partner = user.active_pair&.user1 == user ? user.active_pair.user2 : user.active_pair.user1
    return unless partner

    partner.notifications.create!(
      notification_kind: "new_post",
      notifiable: self
    )
  end
end
