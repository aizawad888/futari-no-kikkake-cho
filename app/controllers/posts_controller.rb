class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_post!, only: [ :edit, :update, :destroy ]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params.except(:reveal_offset_seconds))

    # 現在アクティブなペアを取得
    active_pair = current_user.active_pair
    if active_pair.nil?
      flash.now[:alert] = "ペアがいないと投稿できません"
      render :new and return
    end

    @post.pair = active_pair

    # reveal_offset_seconds が選択されていれば reveal_at に変換
    if post_params[:reveal_offset_seconds].present?
      @post.reveal_at = Time.current + post_params[:reveal_offset_seconds].to_i.seconds
      # フォーム再表示用に仮属性にも保持
      @post.reveal_offset_seconds = post_params[:reveal_offset_seconds]
    end

    if @post.save
      redirect_to main_path, notice: "投稿しました"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    # メモを表示
    @post_memo = @post.post_memos.find_by(user: current_user)
    # メモがなければ表示用に新規作成
    @post_memo ||= @post.post_memos.build(user: current_user)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: "更新しました"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to main_path, notice: "削除しました"
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post!
    return if @post.user == current_user

    redirect_to main_path, alert: "権限がありません" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(
      :title,
      :category_id,
      :sense_level,
      :reveal_at,
      :reveal_offset_seconds
    )
  end
end
