FactoryBot.define do
  factory :anniversary do
    association :pair
    title { "記念日" }
    date { Date.current }
    repeat_type { :no_repeat }
  end
end
