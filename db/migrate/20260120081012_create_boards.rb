class CreateBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :boards do |t|
      t.references :pair, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
