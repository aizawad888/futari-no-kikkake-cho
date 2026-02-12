class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  # 通知作成後にプッシュ通知を送信
  after_create_commit :send_push_notification

  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end


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

  private

  def send_push_notification
    # ユーザーの通知設定を確認
    setting = user.user_notification_settings.find_by(
      notification_kind: notification_kind
    )

    # プッシュ通知が有効な場合のみ送信
    return unless setting&.push_enabled?

    # バックグラウンドジョブで送信（後述）
    SendPushNotificationJob.perform_later(id)
  end
end
