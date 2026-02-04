class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user! # ログイン必須にする（devise使用の場合）

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(
      endpoint: subscription_params[:endpoint]
    )

    subscription.assign_attributes(
      p256dh: subscription_params[:keys][:p256dh],
      auth: subscription_params[:keys][:auth]
    )

    if subscription.save
      render json: { success: true }, status: :created
    else
      render json: { success: false, errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, keys: [ :p256dh, :auth ])
  end
end
