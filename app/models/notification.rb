class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  # 通知の種類を定義
  enum notification_kind: {
    new_post: "new_post",
    post_unlocked: "post_unlocked",
    anniversary: "anniversary",
    weekly_summary: "weekly_summary"
  }

  # 既読判定
  def read?
    read_at.present?
  end

  # 既読にする
  def mark_as_read!
    update(read_at: Time.current) unless read?
  end

  # 表示用メッセージ
  def message
    case notification_kind
    when "new_post"
      "新しい投稿があったよ!"
    when "post_unlocked"
      "答えが見られるようになったよ!"
    when "anniversary"
      "今日は記念日だよ!"
    when "weekly_summary"
      "今週のまとめだよ!"
    end
  end
end
