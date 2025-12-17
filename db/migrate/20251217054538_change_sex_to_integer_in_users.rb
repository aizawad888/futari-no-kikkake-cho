class ChangeSexToIntegerInUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :sex_tmp, :integer

    User.reset_column_information

    User.find_each do |user|
      case user.sex
      when "man"
        user.update_column(:sex_tmp, 0)
      when "woman"
        user.update_column(:sex_tmp, 1)
      when "other"
        user.update_column(:sex_tmp, 2)
      end
    end

    remove_column :users, :sex
    rename_column :users, :sex_tmp, :sex
  end

  def down
    add_column :users, :sex_tmp, :string

    User.reset_column_information

    User.find_each do |user|
      sex_string =
        case user.sex
        when 0 then "man"
        when 1 then "woman"
        when 2 then "other"
        end

      user.update_column(:sex_tmp, sex_string)
    end

    remove_column :users, :sex
    rename_column :users, :sex_tmp, :sex
  end
end
