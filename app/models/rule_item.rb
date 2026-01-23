class RuleItem < ApplicationRecord
  belongs_to :pair
  belongs_to :user

  validates :title, presence: true
  validates :title, uniqueness: { scope: [ :pair_id, :user_id ], message: ":同じタイトルのルールはすでに登録済みです" }
end
