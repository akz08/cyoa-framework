class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users, :id => false do |t|
  		t.integer :uid, :limit => 8,     null: false
  		t.string :first_name
  		t.string :last_name
  		t.string :gender
  		t.text :encrypted_email
  		t.text :encrypted_fb_token
      # t.string :app_token
  		t.timestamps
  	end
  	add_index :users, ['uid'], unique: true
  end
end