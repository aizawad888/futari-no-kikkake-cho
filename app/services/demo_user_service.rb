class DemoUserService
  DEMO_USER1_EMAIL = "demo_user1@example.com"
  DEMO_USER2_EMAIL = "demo_user2@example.com"

  class << self
    # デモユーザーでログインする際のメイン処理
    def setup_and_return_user
      cleanup
      user1, user2 = create_users
      pair = create_pair(user1, user2)
      create_posts(user1, user2, pair)
      create_notifications(user1)

      user1 # ログインするユーザーを返す
    end

    private

    def cleanup
      demo_users = User.where(email: [ DEMO_USER1_EMAIL, DEMO_USER2_EMAIL ])
      return if demo_users.empty?

      # トランザクションで確実に削除
      ActiveRecord::Base.transaction do
        Post.where(user: demo_users).destroy_all
        Notification.where(user: demo_users).destroy_all

        pair_ids = demo_users.pluck(:pair_id).compact.uniq
        Pair.where(id: pair_ids).destroy_all

        demo_users.destroy_all
      end
    end

    def create_users
      user1 = User.create!(
        email: DEMO_USER1_EMAIL,
        password: "password",
        password_confirmation: "password",
        name: "あなた(デモ)",
        sex: 1,
        my_code: SecureRandom.alphanumeric(8).upcase,
        icon: "icon_user_1.png"
      )

      user2 = User.create!(
        email: DEMO_USER2_EMAIL,
        password: "password",
        password_confirmation: "password",
        name: "パートナー(デモ)",
        sex: 2,
        my_code: SecureRandom.alphanumeric(8).upcase,
        icon: "icon_user_3.png"
      )

      [ user1, user2 ]
    end

    def create_pair(user1, user2)
      pair = Pair.create!(
        user_id1: user1.id,
        user_id2: user2.id,
        active: true
      )

      user1.update!(pair_id: pair.id)
      user2.update!(pair_id: pair.id)

      pair
    end

    def create_posts(user1, user2, pair)
      # 過去の投稿（すでに公開済み）
      past_post = Post.create!(
        user: user2,
        pair: pair,
        category_id: 2,
        title: "キッチンの排水溝を掃除しました",
        reveal_at: 2.hours.ago,
        sense_level: 2,
        created_at: 3.hours.ago
      )

      # 新しい投稿（まだ非公開）
      new_post = Post.create!(
        user: user2,
        pair: pair,
        category_id: 8,
        title: "今日の夜褒めてほしい!",
        reveal_at: 1.minute.from_now,
        sense_level: 0,
        created_at: 30.minutes.ago
      )

      [ past_post, new_post ]
    end

    def create_notifications(user1)
      # 最新の公開済み投稿を取得
      past_post = Post.where(user: User.find_by(email: DEMO_USER2_EMAIL))
                      .where("reveal_at < ?", Time.current)
                      .order(created_at: :desc)
                      .first

      return unless past_post

      Notification.create!(
        user: user1,
        notifiable: past_post,
        notification_kind: "post_unlocked",
        created_at: 2.hours.ago,
        read_at: nil
      )
    end
  end
end
