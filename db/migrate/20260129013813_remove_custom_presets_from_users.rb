class RemoveCustomPresetsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :custom_presets, :text
  end
end
