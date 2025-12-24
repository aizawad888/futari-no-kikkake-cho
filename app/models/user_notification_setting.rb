class UserNotificationSetting < ApplicationRecord
  belongs_to :user

  # 通知の種類
  NOTIFICATION_KINDS = %w[new_post post_unlocked anniversary weekly_summary].freeze

  # 各通知種別で許可される頻度
  FREQUENCY_OPTIONS = {
    "new_post" => %w[immediate daily],
    "post_unlocked" => %w[immediate],
    "anniversary" => %w[immediate],
    "weekly_summary" => %w[weekly]
  }.freeze

  # デフォルト頻度
  DEFAULT_FREQUENCIES = {
    "new_post" => "immediate",
    "post_unlocked" => "immediate",
    "anniversary" => "immediate",
    "weekly_summary" => "weekly"
  }.freeze

  validates :notification_kind,
            presence: true,
            inclusion: { in: NOTIFICATION_KINDS },
            uniqueness: { scope: :user_id }

  validates :frequency,
            presence: true,
            inclusion: { in: ->(r) { FREQUENCY_OPTIONS[r.notification_kind] } }

  validates :push_enabled, inclusion: { in: [ true, false ], message: "must be true or false" }

  # new_post だけ頻度変更可能
  def frequency_changeable?
    notification_kind == "new_post"
  end

  # 通知を送信すべきか
  def should_notify?
    push_enabled?
  end
end
