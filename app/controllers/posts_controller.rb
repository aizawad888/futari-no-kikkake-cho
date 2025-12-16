class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_post!, only: [ :edit, :update, :destroy ]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.pair = Pair.find_by("user_id1 = ? OR user_id2 = ?", current_user.id, current_user.id)
    if @post.save
      redirect_to main_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
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

    redirect_to main_path, alert: "権限がありません"
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :category_id,
      :sense_level,
      :reveal_at
    )
  end
end
