class MainController < ApplicationController
  def index
    # ログイン中ユーザーのペアを取得
    @pair = Pair.find_by("user_id1 = ? OR user_id2 = ?", current_user.id, current_user.id)

    # 相手ユーザーを取得
    @partner = @pair.user1 == current_user ? @pair.user2 : @pair.user1

    # 自分と相手の投稿をまとめて取得（最新順）
    @posts = Post.where(user: [ current_user, @partner ]).order(created_at: :desc)
  end
end
