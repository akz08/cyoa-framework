class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.belongs_to :scene, index: true
			t.text :text, null: false
			t.boolean :is_incoming, null: false
			t.integer :parent_id, null: true
		end
	end
end