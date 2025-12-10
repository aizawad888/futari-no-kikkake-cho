class ApplicationController < ActionController::Base
  # Devise のサインアップやアカウント更新時に追加カラムを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # サインアップ時に追加カラムを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :sex, :icon ])

    # アカウント編集時に追加カラムを許可（任意）
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :sex, :icon ])
  end
end
