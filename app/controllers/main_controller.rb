class MainController < ApplicationController
  before_action :authenticate_user!
  before_action :check_demo_mode

  def index
    # 既読処理 @last_viewed_at は New バッジ判定用
    @last_viewed_at = current_user.last_viewed_at
    current_user.update_column(:last_viewed_at, Time.current)

    # ログイン中ユーザーの「有効ペア」を取得
    @pair = Pair.where(active: true)
                .where("user_id1 = ? OR user_id2 = ?", current_user.id, current_user.id)
                .first

    # ペア未設定・無効ペアの場合
    if @pair.nil?
      @partner = nil
      @posts = []
      return
    end

    # 相手ユーザーを取得
    @partner = @pair.user1 == current_user ? @pair.user2 : @pair.user1

    # 自分と相手の投稿をまとめて取得
    @posts = @pair.posts.includes(:category, :user)

    # 並び替え
    @posts = case params[:sort]
    when "priority"
              @posts.order(sense_level: :desc, created_at: :desc)
    when "reveal"
              # 答え合わせ済みは下、未答え合わせは reveal_at 昇順
              @posts.order(
                Arel.sql("CASE WHEN reveal_at <= NOW() THEN 1 ELSE 0 END ASC, reveal_at ASC")
              )
    else
              @posts.order(created_at: :desc)
    end

    # 新着通知作成
    @posts.each do |post|
      if post.just_unlocked?(@last_viewed_at)
        post.create_post_unlocked_notification!
      end
    end
  end

  private

  def check_demo_mode
    if current_user&.email == DemoUserService::DEMO_USER1_EMAIL
      @show_demo_modal = session.delete(:show_demo_modal)  # nilなら表示されない
    end
  end
end
