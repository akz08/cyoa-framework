class CreateCharactersAndUsers < ActiveRecord::Migration
	def change
		create_table :characters_users, id: false do |t|
			t.belongs_to :character, index: true
			t.integer :fb_user_id, index: true
			t.timestamps
		end
	end
end