class NotificationSettingsController < ApplicationController
  before_action :authenticate_user! 

  def show
    # 設定がなければ初期化
    current_user.initialize_notification_settings!
    
    @notification_settings = current_user.user_notification_settings
                                        .order(:notification_kind)
  end

  def update
    success = true
    
    ActiveRecord::Base.transaction do
      params[:user_notification_settings]&.each do |id, attrs|
        setting = current_user.user_notification_settings.find(id)
        
        case setting.notification_kind
        when 'new_post'
          # new_postは頻度を選択可能
          update_new_post_setting(setting, attrs[:frequency])
          
        when 'weekly_summary'
          # 週刊まとめはON/OFFのみ
          update_weekly_summary_setting(setting, attrs[:enabled])
          
        when 'post_unlocked', 'anniversary'
          # すぐ通知 or 通知しないのみ
          update_immediate_setting(setting, attrs[:enabled])
        end
        
        unless setting.save
          success = false
          raise ActiveRecord::Rollback
        end
      end
    end

    if success
      redirect_to notification_settings_path, notice: t('.success')
    else
      flash.now[:alert] = t('.failure')
      @notification_settings = current_user.user_notification_settings
                                          .order(:notification_kind)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def update_new_post_setting(setting, frequency)
    case frequency
    when 'immediate', 'daily'
      setting.push_enabled = true
      setting.frequency = frequency
    when 'none'
      setting.push_enabled = false
      setting.frequency = nil
    end
  end

  def update_weekly_summary_setting(setting, enabled)
    setting.push_enabled = (enabled == '1' || enabled == true)
    setting.frequency = 'weekly' # 固定
  end

  def update_immediate_setting(setting, enabled)
    setting.push_enabled = (enabled == '1' || enabled == true)
    setting.frequency = 'immediate' # 固定
  end
end