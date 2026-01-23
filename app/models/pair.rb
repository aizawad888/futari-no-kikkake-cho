class Pair < ApplicationRecord
  belongs_to :user1, class_name: "User", foreign_key: "user_id1"
  belongs_to :user2, class_name: "User", foreign_key: "user_id2"

  validates :user_id1, uniqueness: { scope: [ :user_id2, :active ], message: "はすでに有効なペアです" }, if: -> { active? }
  validates :user_id2, uniqueness: { scope: [ :user_id1, :active ], message: "はすでに有効なペアです" }, if: -> { active? }

  has_many :posts, dependent: :nullify
  has_many :anniversaries, dependent: :destroy
  has_one :board, dependent: :destroy

  has_many :rule_items, dependent: :destroy


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

  # ２人のルールブックの初期タイトル
  after_create :copy_basic_rules_to_pair

  def copy_basic_rules_to_pair
    fixed_rules = {
    "家事の優先度" => "掃除や洗濯、料理など、あなたが大事にしたい順番や考えを書いておきましょう",
    "お金のルール" => "お小遣いや貯金、共有費用のことなど、自分の考えをまずメモしてみましょう",
    "睡眠や休息の優先度" => "寝る時間や休みたい時間など、あなたの大事にしたいリズムを書き留めておきましょう",
    "連絡の取り方" => "連絡の頻度やタイミングの希望など、自分の感じ方をメモしておきましょう",
    "大事にしたい時間" => "家族や趣味、自分の時間など、優先したいことを自由に書いておきましょう"
  }

    [ user1, user2 ].each do |user|
      fixed_rules.each do |title, example_memo|
        RuleItem.find_or_create_by!(pair: self, user: user, title: title, is_custom: false) do |ri|
          ri.memo = example_memo
        end
      end
    end
  end
end
