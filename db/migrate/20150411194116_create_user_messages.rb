class CreateUserMessages < ActiveRecord::Migration
	def change
		create_table :user_messages, :id => false do |t|
			t.references :user, null: false
			t.references :message, null: false
			t.datetime :datetime, null: false
		end
		add_index :user_messages, [:user_id, :message_id], unique: true
	end
end