class PagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to main_path # ログイン済みはメインページへ
    else
      redirect_to new_user_session_path # 未ログインはログインページへ
    end
  end
end
