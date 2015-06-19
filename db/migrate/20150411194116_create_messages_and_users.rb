class CreateMessagesAndUsers < ActiveRecord::Migration
	def change
		create_table :messages_users, id: false do |t|
			t.belongs_to :message, index: true
			t.belongs_to :user, index: true
			t.timestamps
		end
	end
end