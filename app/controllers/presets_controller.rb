class PresetsController < ApplicationController
  before_action :set_preset, only: [ :edit, :update, :destroy ]

  def index
    @presets = current_user.presets.order(created_at: :desc)
    @preset = current_user.presets.new
  end

    def create
      @preset = current_user.presets.build(preset_params)
      if @preset.save
        redirect_to presets_path, notice: "プリセットを追加しました"
      else
        @presets = current_user.presets.order(created_at: :desc)
        render :index, status: :unprocessable_entity
      end
    end

  def edit
    # @preset は before_action で取得済み
  end

  def update
    if @preset.update(preset_params)
      redirect_to presets_path, notice: "プリセットを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @preset.destroy
    redirect_to presets_path, notice: "プリセットを削除しました"
  end

  private

  def set_preset
    @preset = current_user.presets.find(params[:id])
  end

  def preset_params
    params.require(:preset).permit(:title)
  end
end
