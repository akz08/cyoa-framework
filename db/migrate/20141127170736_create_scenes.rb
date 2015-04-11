class CreateScenes < ActiveRecord::Migration
	def change
		create_table :scenes do |t|
			t.integer :character_id,	null: false
			t.string :information,		null: false
		end 
	end
end
