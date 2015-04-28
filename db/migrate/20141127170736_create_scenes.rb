class CreateScenes < ActiveRecord::Migration
	def change
		create_table :scenes do |t|
			t.references :character, null: false, index: true
			t.text :information, null: false
		end
	end
end