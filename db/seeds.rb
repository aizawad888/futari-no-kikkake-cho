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
    name: "ふたりの時間",
    icon: "icons/two.png",
    hint_text: "ふたりのことで小さな変化があったかも？"
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
  Category.find_or_create_by(name: data[:name]) do |c|
    c.icon = data[:icon]
    c.hint_text = data[:hint_text]
  end
end
