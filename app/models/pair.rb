class Pair < ApplicationRecord
  belongs_to :user1, class_name: "User", foreign_key: "user_id1"
  belongs_to :user2, class_name: "User", foreign_key: "user_id2"

  validates :user_id1, uniqueness: { scope: [ :user_id2, :active ], message: "はすでに有効なペアです" }, if: -> { active? }
  validates :user_id2, uniqueness: { scope: [ :user_id1, :active ], message: "はすでに有効なペアです" }, if: -> { active? }

  has_many :posts, dependent: :nullify
  has_many :anniversaries, dependent: :destroy
  has_one :board, dependent: :destroy


  # 自分のパートナーを返す
  def partner(current_user)
    if current_user == user1
      user2
    elsif current_user == user2
      user1
    else
      nil
    end
  end
end
