class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :notifications, dependent: :destroy
  has_many :user_notification_settings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_memos, dependent: :destroy

  # 性別 変換
  enum sex: { man: 0, woman: 1, other: 2 }

  # ペア
  has_many :pairs_as_user1, class_name: "Pair", foreign_key: :user_id1, dependent: :nullify
  has_many :pairs_as_user2, class_name: "Pair", foreign_key: :user_id2, dependent: :nullify

  # 自分の有効なペアを返す
  def active_pair
    (pairs_as_user1 + pairs_as_user2).find(&:active)
  end

  # バリデーション
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :sex, presence: true
  validates :icon, presence: true

  # ユーザー作成時に自動でmy_codeを発行
  after_create :ensure_my_code

  # ペアコードが空欄な場合の自動発行
  def ensure_my_code
    return if my_code.present?  # 既にコードがあれば何もしない
    generate_my_code
  end

  def generate_my_code
    self.my_code = loop do
      code = SecureRandom.hex(4)
      break code unless User.exists?(my_code: code)
    end
    save!
  end

  # ペアコードで相手と紐付ける共通ロジック
  def pair_with(partner_code)
    partner = User.find_by(my_code: partner_code)

    # バリデーション
    return { success: false, error: "ペアコードが間違っています" } if partner.nil?
    return { success: false, error: "自分自身とはペアを組めません" } if partner == self
    return { success: false, error: "どちらかのユーザーはすでにペアを組んでいます" } if active_pair || partner.active_pair

    # user_id の順序を統一
    ids = [ id, partner.id ].sort
    pair = Pair.find_or_initialize_by(user_id1: ids[0], user_id2: ids[1])
    pair.active = true

    if pair.save
      { success: true, pair: pair }
    else
      { success: false, error: "ペアの作成に失敗しました" }
    end
  end

  # ペア解消の共通ロジック
  def unpair
    pair = active_pair
    return { success: false, error: "有効なペアが見つかりません" } if pair.nil?

    pair.update!(active: false)

    # my_code を新しいものに再生成
    [ pair.user1, pair.user2 ].each(&:generate_my_code)

    { success: true }
  end
end
