# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def demo
    demo_user = DemoUserService.setup_and_return_user
    sign_in demo_user

    # モーダル表示フラグをセット（ホームで1回だけ表示）
    session[:show_demo_modal] = true

    redirect_to main_path, notice: "デモモードでログインしました"
  rescue StandardError => e
    Rails.logger.error("デモモード初期化エラー: #{e.message}")
    redirect_to root_path, alert: "デモモードの初期化に失敗しました"
  end
end
