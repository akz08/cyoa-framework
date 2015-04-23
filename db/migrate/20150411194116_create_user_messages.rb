class CreateUserMessages < ActiveRecord::Migration
	def change
		create_table :user_messages, :id => false do |t|
			t.integer :user_id, null: false
			t.integer :message_id, null: false
			t.datetime :datetime, null: false
		end
		add_foreign_key :user_messages, :user_id
		add_foreign_key :user_messages, :message_id
		add_index :user_messages, [:user_id, :message_id], unique: true
	end
end