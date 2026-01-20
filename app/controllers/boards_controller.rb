class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pair
  before_action :set_board

  def show
    @anniversaries = @pair.anniversaries.order(:date)
  end

  def update
    if @board.update(board_params)
      redirect_to board_path, notice: "保存しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_pair
    @pair = current_user.active_pair
    redirect_to(root_path, alert: "ペアが存在しません") unless @pair
  end

  def set_board
    @board = @pair.board || @pair.create_board
  end

  def board_params
    params.require(:board).permit(:content)
  end
end
