class AddLastViewedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :last_viewed_at, :datetime
  end
end
