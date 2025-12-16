class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_my_code, only: [ :show ]

  def show
    @user = current_user
  end

  # 再発行ボタン用
  def regenerate_code
    current_user.generate_my_code
    current_user.save!
    redirect_to user_path(current_user), notice: "ペアコードを再発行しました"
  end

  private

  def ensure_my_code
    current_user.ensure_my_code
  end
end
