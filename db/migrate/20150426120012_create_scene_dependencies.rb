class CreateSceneDependencies < ActiveRecord::Migration
	def change
		create_table :scene_dependencies, id: false do |t|
			t.references :scene, null: false
			t.references :message, null: false
		end
		add_index :scene_dependencies, [:scene_id, :message_id], unique: true
	end
end