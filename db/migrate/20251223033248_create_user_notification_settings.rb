class CreateUserNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_kind, null: false
      t.boolean :push_enabled, null: false, default: true
      t.string :frequency

      t.timestamps
    end

    add_index :user_notification_settings,
              [:user_id, :notification_kind],
              unique: true,
              name: "index_user_notification_settings_unique"
  end
end
