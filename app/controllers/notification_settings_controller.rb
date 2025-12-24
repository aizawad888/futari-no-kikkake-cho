class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    order = {
      "new_post" => 1,
      "post_unlocked" => 2,
      "weekly_summary" => 3,
      "anniversary" => 4
    }
    @notification_settings =
    current_user.user_notification_settings
                .sort_by { |s| order[s.notification_kind] || 99 }
  end


  def update
    success = true

    ActiveRecord::Base.transaction do
      params[:user_notification_settings]&.each do |id, attrs|
        setting = current_user.user_notification_settings.find(id)

        if attrs[:frequency].present?
          # ON
          setting.push_enabled = true
          setting.frequency = attrs[:frequency]
        else
          # OFF（frequency は通知種別のデフォルトに戻す）
          setting.push_enabled = false
          setting.frequency = UserNotificationSetting::DEFAULT_FREQUENCIES[setting.notification_kind]
        end

        unless setting.save
          Rails.logger.debug "SAVE FAILED: #{setting.errors.full_messages}"
          success = false
          raise ActiveRecord::Rollback
        end
      end
    end

    if success
      redirect_to notification_settings_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      @notification_settings = current_user.user_notification_settings
      render :show, status: :unprocessable_entity
    end
  end
end
