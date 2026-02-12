class SocialAccountsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    unless current_user.password_set?
      redirect_to edit_user_path(current_user),
                  alert: "連携解除するにはパスワードの設定が必要です"
      return
    end

    current_user.update(provider: nil, uid: nil)

    redirect_to user_path(current_user), notice: "Google連携を解除しました"
  end
end
