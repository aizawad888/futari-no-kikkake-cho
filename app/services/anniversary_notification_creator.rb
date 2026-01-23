class AnniversaryNotificationCreator
  def self.call
    Anniversary.includes(:pair).find_each do |anniversary|
      next unless anniversary.today?

      users = [
        anniversary.pair.user1,
        anniversary.pair.user2
      ].compact

      users.each do |user|
        next if Notification.exists?(
          user: user,
          notifiable: anniversary,
          notification_kind: :anniversary,
          created_at: Time.current.all_day
        )

        Notification.create!(
          user: user,
          notifiable: anniversary,
          notification_kind: :anniversary,
        )
      end
    end
  end
end
