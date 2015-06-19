class CreateCharactersAndUsers < ActiveRecord::Migration
	def change
		create_table :characters_users, id: false do |t|
			t.belongs_to :character, index: true
			t.belongs_to :user, index: true
			t.timestamps
		end
	end
end