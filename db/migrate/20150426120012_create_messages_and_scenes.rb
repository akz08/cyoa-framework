class CreateMessagesAndScenes < ActiveRecord::Migration
	def change
		create_table :messages_scenes, id: false do |t|
			t.belongs_to :message, index: true
			t.belongs_to :scene, index: true
		end
	end
end