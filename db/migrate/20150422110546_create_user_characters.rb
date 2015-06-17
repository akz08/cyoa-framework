class CreateUserCharacters < ActiveRecord::Migration
	def change
		create_table :user_characters, id: false do |t|
			t.integer :fb_user_id, null: false
			t.integer :character_id, null: false
			t.timestamps
		end
		add_index :user_characters, [:fb_user_id, :character_id], unique: true
	end
end