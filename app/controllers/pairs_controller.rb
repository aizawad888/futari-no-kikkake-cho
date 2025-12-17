class PairsController < ApplicationController
  def new
    @pair = Pair.new
  end

  def create
    result = current_user.pair_with(params[:pair][:partner_code])
    
    if result[:success]
      redirect_to user_path(current_user), notice: "ペアを作成しました"
    else
      redirect_to new_pair_path, alert: result[:error]
    end
  end

  def destroy  
    result = current_user.unpair
    
    if result[:success]
      redirect_to user_path(current_user), notice: "ペアを解消しました"
    else
      redirect_to user_path(current_user), alert: result[:error]
    end
  end
end