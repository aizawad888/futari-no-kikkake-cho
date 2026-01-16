class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "マイページを更新しました"
    else
      render :edit
    end
  end

  # 再発行ボタン用
  def regenerate_code
    current_user.generate_my_code
    redirect_to user_path(current_user), notice: "ペアコードを再発行しました"
  end

  # ユーザー削除(ユーザー削除前にペア削除処理)
  def destroy
    ActiveRecord::Base.transaction do
      current_user.unpair if current_user.active_pair
      current_user.destroy!
    end

    reset_session
    redirect_to root_path, notice: "退会が完了しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :sex, :icon)
  end
end
