class UserNotificationSetting < ApplicationRecord
  belongs_to :user

  # 通知の種類（enumは使わない）
  NOTIFICATION_KINDS = %w[new_post post_unlocked anniversary weekly_summary].freeze

  # 各通知種別のデフォルト頻度
  DEFAULT_FREQUENCIES = {
    'new_post' => 'immediate',      # デフォルトはすぐ通知
    'post_unlocked' => 'immediate', # 固定：すぐ通知
    'anniversary' => 'immediate',   # 固定：すぐ通知
    'weekly_summary' => 'weekly'    # 固定：週1回
  }.freeze

  # 頻度を変更可能な通知種別
  FREQUENCY_CHANGEABLE_KINDS = ['new_post'].freeze

  validates :notification_kind, presence: true, 
            inclusion: { in: NOTIFICATION_KINDS }
  validates :user_id, uniqueness: { scope: :notification_kind }
  validates :frequency, inclusion: { 
    in: ['immediate', 'daily', 'weekly', nil],
    allow_nil: true 
  }

  # 頻度が変更可能かどうか
  def frequency_changeable?
    FREQUENCY_CHANGEABLE_KINDS.include?(notification_kind)
  end

  # 実際に使用する頻度を返す
  def effective_frequency
    return nil unless push_enabled
    
    if frequency_changeable?
      frequency || DEFAULT_FREQUENCIES[notification_kind]
    else
      DEFAULT_FREQUENCIES[notification_kind]
    end
  end

  # 通知を送信すべきかどうか
  def should_notify?
    push_enabled && effective_frequency.present?
  end
end