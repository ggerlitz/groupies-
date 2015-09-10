class ChangeUserId < ActiveRecord::Migration
  def change
  	change_column :users, :user_id, :integer
  end
end
