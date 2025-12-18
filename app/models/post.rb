class Post < ApplicationRecord
  belongs_to :user
  belongs_to :pair, optional: true
  belongs_to :category
  has_many :post_memos, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title, presence: true
  validates :reveal_at, presence: true


  enum sense_level: {
    low: 0,
    medium: 1,
    high: 2
  }

  def sense_level_jp
    case sense_level
    when "low" then "低"
    when "medium" then "中"
    when "high" then "高"
    end
  end

  # select用に引数付きメソッド
  def self.sense_level_jp_for(key)
    case key
    when "low" then "低"
    when "medium" then "中"
    when "high" then "高"
    end
  end

  def title_for_view(viewer)
    if user == viewer
      title
    else
      Time.current < reveal_at ? category.hint_text : title
    end
  end
end
