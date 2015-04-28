class CreateUserCharacters < ActiveRecord::Migration
	def change
		create_table :user_characters, id: false do |t|
			t.references :user, null: false
			t.references :character, null: false
		end
		add_index :user_characters, [:user_id, :character_id], unique: true
	end
end