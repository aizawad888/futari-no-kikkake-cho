class PairsController < ApplicationController
  before_action :set_pair, only: [ :dissolve ]

  def new
    @pair = Pair.new
  end

  def create
    partner = User.find_by(my_code: params[:pair][:partner_code])
    if partner.nil?
      redirect_to new_pair_path, alert: "ペアコードが間違っています" and return
    end

    # すでに有効なペアがあるか確認
    if current_user.active_pair || partner.active_pair
      redirect_to new_pair_path, alert: "どちらかのユーザーはすでにペアを組んでいます" and return
    end

    # user_id の順序を統一(user_id の小さい方を user_id1 にする)
    ids = [ current_user.id, partner.id ].sort
    @pair = Pair.find_or_initialize_by(user_id1: ids[0], user_id2: ids[1])
    @pair.active = true

    if @pair.save
      redirect_to user_path(current_user), notice: "ペアを作成しました"
    else
      render :new
    end
  end

  def dissolve
    @pair.update!(active: false)

    # my_code を新しいものに再生成（Userモデルに public メソッド作成済みの場合）
    [ @pair.user1, @pair.user2 ].each do |user|
      user.generate_my_code
    end

    redirect_to user_path(current_user), notice: "ペアを解消しました"
  end

  private

  def set_pair
    @pair = Pair.find(params[:id])
  end
end
