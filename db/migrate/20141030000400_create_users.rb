class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :u_id
  		t.string :u_first_name
  		t.string :u_last_name
  		t.string :u_gender
  		t.string :u_email
  		t.string :fb_token
  		t.timestamps
  	end
  	add_index :users, :u_id
  end
end
