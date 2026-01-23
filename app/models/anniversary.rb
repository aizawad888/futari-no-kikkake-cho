class Anniversary < ApplicationRecord
  belongs_to :pair

  enum repeat_type: {
    no_repeat: 0,
    monthly: 1,
    yearly: 2
  }

  validates :title, :date, :repeat_type, presence: true

  def today?
    today = Date.current

    case repeat_type.to_sym
    when :no_repeat
      date == today
    when :monthly
      date.day == today.day
    when :yearly
      date.month == today.month && date.day == today.day
    end
  end
end
