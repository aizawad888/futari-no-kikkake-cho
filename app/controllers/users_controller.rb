class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  # 再発行ボタン用
  def regenerate_code
    current_user.generate_my_code
    redirect_to user_path(current_user), notice: "ペアコードを再発行しました"
  end
end
