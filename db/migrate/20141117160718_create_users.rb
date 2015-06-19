class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users, id: false do |t|
			t.integer :fb_user_id, limit: 8
			t.string :first_name, null: true
			t.string :last_name, null: true
			t.string :encrypted_email, null: true
			t.timestamps
		end
		add_index :users, :fb_user_id, unique: true
	end
end