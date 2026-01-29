class Preset < ApplicationRecord
  belongs_to :user
  validates :title, presence: true,
                    uniqueness: { scope: :user_id, message: ":同じタイトルがすでに登録されています" }
end
