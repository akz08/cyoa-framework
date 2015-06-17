class CreateUserMessages < ActiveRecord::Migration
	def change
		create_table :user_messages, id: false do |t|
			t.integer :fb_user_id, null: false
			t.integer :message_id, null: false
			t.timestamps
		end
		add_index :user_messages, [:fb_user_id, :message_id], unique: true
	end
end