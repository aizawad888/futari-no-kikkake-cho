class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿
  has_many :posts, dependent: :destroy

  # ペア
  has_many :pairs_as_user1, class_name: "Pair", foreign_key: :user_id1, dependent: :nullify
  has_many :pairs_as_user2, class_name: "Pair", foreign_key: :user_id2, dependent: :nullify

  # 自分の有効なペアを返す
  def active_pair
    (pairs_as_user1 + pairs_as_user2).find(&:active)
  end

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # ペアコードが空欄な場合の自動発行
  def ensure_my_code
    generate_my_code if my_code.blank?
    save! if changed?
  end

  def generate_my_code
    self.my_code = loop do
      code = SecureRandom.hex(4)
      break code unless User.exists?(my_code: code)
    end
    save!
  end
end
