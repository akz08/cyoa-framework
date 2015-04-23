class CreateUserCharacters < ActiveRecord::Migration
	def change
		create_table :user_characters, :id => false do |t|
			t.integer :user_id, null: false
			t.integer :character_id, null: false
		end
		add_foreign_key :user_characters, :user_id
		add_foreign_key :user_characters, :character_id
		add_index :user_characters, [:user_id, :character_id], unique: true
	end
end