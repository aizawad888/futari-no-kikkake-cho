class AddNameToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :name, :string
  end
end
