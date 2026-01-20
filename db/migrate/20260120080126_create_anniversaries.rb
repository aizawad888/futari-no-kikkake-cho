class CreateAnniversaries < ActiveRecord::Migration[7.0]
  def change
    create_table :anniversaries do |t|
      t.references :pair, null: false, foreign_key: true
      t.string :title, null: false
      t.date :date, null: false
      t.integer :repeat_type, null: false, default: 0

      t.timestamps
    end
  end
end
