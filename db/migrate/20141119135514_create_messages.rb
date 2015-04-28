class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.references :scene, null: false, index: true
			t.text :text, null: false
			t.boolean :is_incoming, null: false
			t.integer :delay
			t.integer :parent_id
		end
	end
end