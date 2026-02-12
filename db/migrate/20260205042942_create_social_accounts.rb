class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :social_accounts, [ :provider, :uid ], unique: true
    add_index :social_accounts, [ :user_id, :provider ], unique: true
  end
end
