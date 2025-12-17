class OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_paired, only: [ :pair ]

  def pair
    # ペアID登録ページを表示
  end

  def create_pair
    result = current_user.pair_with(params[:partner_code])

    if result[:success]
      redirect_to main_path, notice: "ペアを作成しました"
    else
      flash.now[:alert] = result[:error]
      render :pair
    end
  end

  def skip
    # ペアID登録をスキップして、メインページへ
    redirect_to main_path, notice: "ペアID登録をスキップしました"
  end

  private

  def redirect_if_paired
    # すでにペアがある場合は、メインページへリダイレクト
    redirect_to main_path if current_user.active_pair
  end
end
