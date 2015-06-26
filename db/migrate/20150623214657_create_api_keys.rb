class CreateApiKeys < ActiveRecord::Migration
	def change
		create_table :api_keys do |t|
			t.string :key, unique: true, index: true
			t.integer :fb_user_id, index: true
			t.boolean :active, default: true
			t.timestamps
		end
	end
end