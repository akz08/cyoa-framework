class CreateMessageSceneDependencies < ActiveRecord::Migration
	def change
		create_table :message_scene_dependencies, id: false do |t|
			t.belongs_to :message, index: true, unique: true
			t.belongs_to :scene, index: true
		end
		add_index :message_scene_dependencies, [ :message_id, :scene_id ], unique: true
	end
end