class MainController < ApplicationController
  before_action :authenticate_user!

  def index
    # 既読処理 @last_viewed_at は New バッジ判定用（前回 index 表示時刻）
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

    # 自分と相手の投稿をまとめて取得（最新順）
    @posts = @pair.posts.order(created_at: :desc).includes(:category, :user)
  end
end
