class AnniversariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pair
  before_action :set_anniversary, only: [ :show, :edit, :update, :destroy ]

  # 一覧
  def index
    @anniversaries = @pair.anniversaries.order(date: :asc).limit(5)
  end

  # 詳細
  def show
  end

  # 新規作成
  def new
    @anniversary = @pair.anniversaries.new
  end

  def create
    @anniversary = @pair.anniversaries.build(anniversary_params)
    if @anniversary.save
      redirect_to board_path, notice: "記念日を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム
  def edit
  end

  # 更新
  def update
    if @anniversary.update(anniversary_params)
      redirect_to board_path, notice: "記念日を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除
  def destroy
    @anniversary.destroy
    redirect_to board_path, notice: "記念日を削除しました"
  end

  private

  def set_pair
    @pair = current_user.active_pair
    redirect_to(root_path, alert: "ペアが存在しません") unless @pair
  end

  def set_anniversary
    @anniversary = @pair.anniversaries.find(params[:id])
  end

  def anniversary_params
    params.require(:anniversary).permit(:title, :date, :repeat_type)
  end
end
