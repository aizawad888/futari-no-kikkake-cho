class MainController < ApplicationController
  def index
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
    @posts = Post.where(user: [ current_user, @partner ])
                 .order(created_at: :desc)
  end
end
