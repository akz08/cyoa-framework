class CreateScenes < ActiveRecord::Migration
	def change
		create_table :scenes do |t|
			t.integer :character_id
			t.string :information
		end 
	end
end
