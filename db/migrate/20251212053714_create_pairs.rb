class CreatePairs < ActiveRecord::Migration[7.2]
  def change
    create_table :pairs do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :pairs, [ :user1_id, :user2_id ], unique: true
  end
end
