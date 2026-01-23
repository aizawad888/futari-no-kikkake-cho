class RuleItemsController < ApplicationController
  before_action :set_pair

  def index
    @rule_items_grouped = RuleItem.where(pair_id: @pair.id)
                                  .order(:created_at) # 作成順
                                  .group_by(&:title)
  end

  def new
    @rule_item = RuleItem.new
  end

  def create
    @rule_item = RuleItem.new(rule_item_params)
    @rule_item.pair = @pair
    @rule_item.user = current_user

    ActiveRecord::Base.transaction do
      @rule_item.save!

      # 相手の空メモを作成（同じタイトルが無ければ）
      partner_user = @pair.user1 == current_user ? @pair.user2 : @pair.user1
      unless RuleItem.exists?(pair: @pair, user: partner_user, title: @rule_item.title)
        RuleItem.create!(pair: @pair, user: partner_user, title: @rule_item.title, memo: "")
      end
    end

    redirect_to rule_items_path, notice: "メモを追加しました"
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @rule_item = RuleItem.find(params[:id])
  end

  def update
    @rule_item = RuleItem.find(params[:id])
    partner_user = @rule_item.pair.user1 == current_user ? @rule_item.pair.user2 : @rule_item.pair.user1
    partner_item = @rule_item.pair.rule_items.find_by(user: partner_user, title: @rule_item.title)

    ActiveRecord::Base.transaction do
      @rule_item.update!(rule_item_params)
      # タイトルを揃える（相手がいる場合）
      partner_item.update!(title: @rule_item.title) if partner_item
    end

    redirect_to rule_items_path, notice: "メモを更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @rule_item = RuleItem.find(params[:id])
    partner_user = @rule_item.pair.user1 == current_user ? @pair.user2 : @pair.user1
    partner_item = @rule_item.pair.rule_items.find_by(user: partner_user, title: @rule_item.title)

    ActiveRecord::Base.transaction do
      @rule_item.destroy!
      partner_item&.destroy!
    end

    redirect_to rule_items_path, notice: "メモを削除しました"
  end

  private

  def set_pair
    @pair = current_user.active_pair
    unless @pair
      redirect_to root_path, alert: "まだペアが登録されていません"
    end
  end

  def rule_item_params
    params.require(:rule_item).permit(:category, :title, :memo, :is_custom)
  end
end
