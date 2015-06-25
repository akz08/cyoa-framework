class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users, primary_key: :fb_user_id do |t|
			t.string :first_name, null: true
			t.string :last_name, null: true
			t.string :encrypted_email, null: true
			t.timestamps
		end
	end
end