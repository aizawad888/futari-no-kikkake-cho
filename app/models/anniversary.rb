class Anniversary < ApplicationRecord
  belongs_to :pair

  enum repeat_type: {
    no_repeat: 0,
    monthly: 1,
    yearly: 2
  }

  validates :title, :date, :repeat_type, presence: true
end
