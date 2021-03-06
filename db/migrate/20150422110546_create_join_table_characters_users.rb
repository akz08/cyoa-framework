class CreateJoinTableCharactersUsers < ActiveRecord::Migration
	def change
		create_table :characters_users, id: false do |t|
			t.belongs_to :character, index: true
			t.integer :fb_user_id, limit: 8, index: true
			t.timestamps
		end
		add_index :characters_users, [ :character_id, :fb_user_id ], unique: true
	end
end