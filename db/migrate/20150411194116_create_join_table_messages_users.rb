class CreateJoinTableMessagesUsers < ActiveRecord::Migration
	def change
		create_table :messages_users, id: false do |t|
			t.belongs_to :message, index: true
			t.integer :fb_user_id, limit: 8, index: true
			t.timestamps
		end
		add_index :messages_users, [ :message_id, :fb_user_id ], unique: true
	end
end