class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.integer :scene_id, null: false
			t.text :text, null: false
			t.boolean :from_self, null: false
			t.integer :parent_id
			t.integer :delay
		end
		add_index :messages, :scene_id
		add_index :messages, :parent_id
	end
end