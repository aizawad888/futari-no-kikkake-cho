class SendDailyPushNotificationsJob < ApplicationJob
  queue_as :default

  def perform(notification_kind)
    settings = UserNotificationSetting.where(
      notification_kind: notification_kind,
      frequency: "daily",
      push_enabled: true
    ).includes(:user)

    settings.each do |setting|
      user = setting.user

      notifications = fetch_daily_notifications(user, notification_kind)

      next if notifications.empty?

      send_daily_summary(user, notifications, notification_kind)
    end
  end

  private

  def fetch_daily_notifications(user, notification_kind)
    start_of_day = Time.current.beginning_of_day

    user.notifications
        .where(notification_kind: notification_kind)
        .where("created_at >= ?", start_of_day)
        .where(read_at: nil)
        .order(created_at: :desc)
  end

  def send_daily_summary(user, notifications, notification_kind)
    return unless user.push_subscriptions.exists?

    message_data = build_daily_message(notifications, notification_kind)

    user.push_subscriptions.each do |subscription|
      send_push(subscription, message_data)
    end
  end

  def build_daily_message(notifications, notification_kind)
    count = notifications.count

    case notification_kind
    when "new_post"
      {
        title: "📝 新しい投稿があります",
        body: "#{count}件の投稿がありました",
        url: notifications_url,
        icon: "/icon-192x192.png",
        badge: "/badge-72x72.png"
      }
    when "anniversary"
      # 記念日が複数件ある場合に対応
      if count == 1
        notification = notifications.first
        {
          title: notification.message,
          body: "🎉 #{notification.notifiable.title}",
          url: notification_url(notification),
          icon: "/icon-192x192.png",
          badge: "/badge-72x72.png"
        }
      else
        # 複数件の場合はまとめて表示
        {
          title: "🎉 今日の予定があります",
          body: "#{count}件の予定があります",
          url: notifications_url,
          icon: "/icon-192x192.png",
          badge: "/badge-72x72.png"
        }
      end
    end
  end

  def send_push(subscription, message_data)
    message = {
      title: message_data[:title],
      body: message_data[:body],
      icon: message_data[:icon],
      badge: message_data[:badge],
      data: { url: message_data[:url] }
    }

    WebPush.payload_send(
      message: JSON.generate(message),
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        subject: "mailto:#{ENV['VAPID_EMAIL']}",
        public_key: ENV["VAPID_PUBLIC_KEY"],
        private_key: ENV["VAPID_PRIVATE_KEY"]
      }
    )

    Rails.logger.info("デイリープッシュ通知を送信しました: #{subscription.id}")
  rescue WebPush::InvalidSubscription, WebPush::ExpiredSubscription => e
    Rails.logger.warn("無効な購読情報: #{e.message}")
    subscription.destroy
  rescue StandardError => e
    Rails.logger.error("プッシュ通知の送信エラー: #{e.message}")
  end

  def notifications_url
    Rails.application.routes.url_helpers.notifications_url(
      host: ENV["APP_HOST"] || "localhost:3000",
      protocol: Rails.env.production? ? "https" : "http"
    )
  end

  def notification_url(notification)
    if notification.post.present?
      Rails.application.routes.url_helpers.post_url(
        notification.post,
        host: ENV["APP_HOST"] || "localhost:3000",
        protocol: Rails.env.production? ? "https" : "http"
      )
    elsif notification.notifiable_type == "Anniversary"
      # 記念日の詳細ページがあればそこへ、なければ通知一覧へ
      notifications_url
    else
      notifications_url
    end
  end
end
