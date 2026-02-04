class CreatePushSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :push_subscriptions do |t|
      t.text :endpoint
      t.text :p256dh
      t.text :auth
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
