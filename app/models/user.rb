class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :generate_my_code

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  private

  def generate_my_code
    # SecureRandom.hex(4) → 8文字のランダム文字列
    self.my_code = loop do
      code = SecureRandom.hex(4)
      break code unless User.exists?(my_code: code)
    end
  end
end
