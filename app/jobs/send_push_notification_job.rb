class SendPushNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)
    user = notification.user

    setting = UserNotificationSetting.find_by(
      user: user,
      notification_kind: notification.notification_kind
    )

    # プッシュOFFなら送らない
    return if setting&.push_enabled == false

    # daily/weeklyの場合は即座に送らない(バッチ処理で送る)
    return unless setting&.frequency == "immediate"

    return unless user.push_subscriptions.exists?

    message_data = build_message(notification)

    user.push_subscriptions.each do |subscription|
      send_push(subscription, message_data)
    end
  rescue StandardError => e
    Rails.logger.error("プッシュ通知の送信に失敗: #{e.message}")
  end

  private

  def build_message(notification)
    case notification.notification_kind
    when "new_post"
      # 投稿が存在する場合は、カテゴリのヒント文言を使用
      body_text = if notification.post.present?
        "📝 #{notification.post.category.hint_text}"
      else
        "新しい投稿がありました"
      end

      {
        title: notification.message,
        body: body_text,
        url: notification_url(notification),
        icon: "/icon-192x192.png",
        badge: "/badge-72x72.png"
      }

    when "post_unlocked"
      # アンロック後は実際のタイトルを表示
      body_text = if notification.post.present?
        "📝 #{notification.post.title}"
      else
        "答えが見られるようになりました"
      end

      {
        title: notification.message,
        body: body_text,
        url: notification_url(notification),
        icon: "/icon-192x192.png",
        badge: "/badge-72x72.png"
      }

    when "anniversary"
      # 記念日の場合は記念日のタイトルを表示
      body_text = if notification.notifiable.present?
        "🎉 #{notification.notifiable.title}"
      else
        "今日は記念日です"
      end

      {
        title: notification.message,
        body: body_text,
        url: notification_url(notification),
        icon: "/icon-192x192.png",
        badge: "/badge-72x72.png"
      }

    else
      # 未知の通知種別の場合
      {
        title: notification.message || "新しい通知",
        body: "通知があります",
        url: root_url,
        icon: "/icon-192x192.png",
        badge: "/badge-72x72.png"
      }
    end
  end

  def send_push(subscription, message_data)
    message = {
      title: message_data[:title],
      body: message_data[:body],
      icon: message_data[:icon],
      badge: message_data[:badge],
      data: {
        url: message_data[:url]
      }
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

    Rails.logger.info("プッシュ通知を送信しました: #{subscription.id}")
  rescue WebPush::InvalidSubscription, WebPush::ExpiredSubscription => e
    Rails.logger.warn("無効な購読情報: #{e.message}")
    subscription.destroy
  rescue StandardError => e
    Rails.logger.error("プッシュ通知の送信エラー: #{e.message}")
    raise
  end

  def notification_url(notification)
    # 通知をクリックしたときの遷移先
    if notification.post.present?
      post_url(notification.post)
    elsif notification.notifiable_type == "Anniversary"
      root_url  # または記念日の詳細ページ
    else
      root_url
    end
  end

  def post_url(post)
    Rails.application.routes.url_helpers.post_url(
      post,
      host: ENV["APP_HOST"] || "localhost:3000",
      protocol: Rails.env.production? ? "https" : "http"
    )
  end

  def root_url
    Rails.application.routes.url_helpers.root_url(
      host: ENV["APP_HOST"] || "localhost:3000",
      protocol: Rails.env.production? ? "https" : "http"
    )
  end
end
