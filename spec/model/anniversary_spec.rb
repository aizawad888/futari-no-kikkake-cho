require "rails_helper"

RSpec.describe Anniversary, type: :model do
  let(:pair) { create(:pair) }

  describe "#today?" do
    context "no_repeat" do
      it "今日ならtrue" do
        anniversary = build(:anniversary,
          pair: pair,
          repeat_type: :no_repeat,
          date: Date.current
        )
        expect(anniversary.today?).to be true
      end

      it "今日でなければfalse" do
        anniversary = build(:anniversary,
          pair: pair,
          repeat_type: :no_repeat,
          date: Date.yesterday
        )
        expect(anniversary.today?).to be false
      end
    end

    context "monthly" do
      it "日が同じならtrue" do
        anniversary = build(:anniversary,
          pair: pair,
          repeat_type: :monthly,
          date: Date.current.prev_month
        )
        anniversary.date = anniversary.date.change(day: Date.current.day)
        expect(anniversary.today?).to be true
      end
    end

    context "yearly" do
      it "月日が同じならtrue" do
        anniversary = build(:anniversary,
          pair: pair,
          repeat_type: :yearly,
          date: Date.current.prev_year
        )
        anniversary.date = Date.new(
          anniversary.date.year,
          Date.current.month,
          Date.current.day
        )
        expect(anniversary.today?).to be true
      end
    end
  end
end
