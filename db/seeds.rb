categories = [
  {
    name: "美容",
    icon: "icons/beauty.png",
    hint_text: "見た目に変化があったみたい！"
  },
  {
    name: "家事",
    icon: "icons/cleaning.png",
    hint_text: "家の中でちょっとした変化があったかも？"
  },
  {
    name: "料理",
    icon: "icons/cooking.png",
    hint_text: "食卓にいつもと違う工夫があるみたい！"
  },
  {
    name: "体調",
    icon: "icons/health.png",
    hint_text: "体調の変化があったみたい！"
  },
  {
    name: "育児",
    icon: "icons/childcare.png",
    hint_text: "育児のことで、ちょっとだけ気付いてほしいことがあるかも…？"
  },
  {
    name: "気持ち",
    icon: "icons/heart.png",
    hint_text: "気持ちに小さな変化があったみたい！"
  },
  {
    name: "ありがとう",
    icon: "icons/thanks.png",
    hint_text: "嬉しかったことがあったかも？"
  },
  {
    name: "おねがい",
    icon: "icons/please.png",
    hint_text: "お願いごとがあるみたい！"
  },
  {
    name: "トーク",
    icon: "icons/talk.png",
    hint_text: "話したいことがあるかも？"
  },
  {
    name: "その他",
    icon: "icons/other.png",
    hint_text: "ちょっとした変化を探してみよう！"
  }
]

categories.each do |data|
  Category.find_or_create_by!(name: data[:name]) do |c|
    c.icon = data[:icon]
    c.hint_text = data[:hint_text]
  end
end


# ふたりのルールブック
fixed_titles = [
  "家事の優先度",
  "お金のルール",
  "睡眠や休息の優先度",
  "連絡の取り方",
  "大事にしたい時間"
]

Pair.find_each do |pair|
  [ pair.user1, pair.user2 ].each do |user|
    fixed_titles.each do |title|
      RuleItem.find_or_create_by!(pair_id: pair.id, user: user, title: title)
    end
  end
end
