class CreateRuleItems < ActiveRecord::Migration[7.2]
  def change
    create_table :rule_items do |t|
      t.references :pair, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :category
      t.string :title
      t.text :memo
      t.boolean :is_custom

      t.timestamps
    end
  end
end
