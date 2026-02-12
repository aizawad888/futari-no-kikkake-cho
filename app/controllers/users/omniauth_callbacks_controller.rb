class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]

    if user_signed_in?
      if User.exists?(provider: auth.provider, uid: auth.uid)
        redirect_to user_path(current_user),
          alert: "このGoogleアカウントはすでに他のユーザーに連携されています"
        return
      end

      current_user.update!(
        provider: auth.provider,
        uid: auth.uid
      )

      redirect_to user_path(current_user),
        notice: "Googleアカウントを連携しました"
      return
    end

    # 🔽 ここからログイン処理

    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.find_by(email: auth.info.email)

      if user
        user.update(provider: auth.provider, uid: auth.uid)
      else
        user = User.create!(
          email: auth.info.email,
          name: auth.info.name,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          uid: auth.uid
        )
      end
    end

    sign_in(user)

    if user.profile_completed?
      redirect_to root_path, notice: "ログインしました"
    else
      redirect_to edit_user_path(user), alert: "プロフィールを完成させてください"
    end
  end
end
