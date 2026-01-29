class AddCustomPresetsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :custom_presets, :text, array: true, default: []
  end
end
