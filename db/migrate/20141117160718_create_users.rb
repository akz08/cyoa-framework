class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users, id: false do |t|
			t.integer :fb_user_id, limit: 8, index: true
			t.string :first_name, null: true
			t.string :last_name, null: true
			t.string :encrypted_email, null: true
			t.timestamps
		end
	end
end