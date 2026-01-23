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

  # 未読の通知を取得するスコープを追加
  scope :unread, -> { where(read_at: nil) }

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
    if notification_kind.to_sym == :anniversary
      I18n.t(
        "enums.notification.notification_kind.anniversary",
        title: notifiable&.title || "記念日"
      )
    else
      I18n.t("enums.notification.notification_kind.#{notification_kind}")
    end
  end

  def post
    notifiable if notifiable_type == "Post"
  end
end
