class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users, :id => false do |t|
  		t.string :uid,      null: false
  		t.string :first_name
  		t.string :last_name
  		t.string :gender
  		t.string :email
  		t.string :fb_token,     null: false
      # t.string :app_token
  		t.timestamps
  	end
  	add_index :users, ['uid'], unique: true
  end
end
