class CreateMessagesAndScenes < ActiveRecord::Migration
	def change
		create_table :messages_scenes, id: false do |t|
			t.belongs_to :message, index: true
			t.belongs_to :scene, index: true
		end
		add_index :messages_scenes, [ :message_id, :scene_id ], unique: true
	end
end