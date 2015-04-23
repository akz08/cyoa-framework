class CreateCharacters < ActiveRecord::Migration
	def change
		create_table :characters do |t|
			t.string :name, null: false
			t.integer :age, null: false
			t.string :gender, null: false
			t.text :description, null: false
			t.boolean :default, null: false
		end
	end
end