class CreateUsersTable < ActiveRecord::Migration
  def change
		create_table :users do |t|
  		t.string :user_id
  		t.string :email
  		t.string :password
  		t.string :fname
  		t.string :lname
  		t.string :username
  		t.string :bio
  	end
  end
end
