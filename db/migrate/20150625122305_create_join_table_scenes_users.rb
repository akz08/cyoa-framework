class CreateJoinTableScenesUsers < ActiveRecord::Migration
	def change
		create_table :scenes_users, id: false do |t|
			t.belongs_to :scene, index: true
			t.integer :fb_user_id, limit: 8, index: true
			t.timestamps
		end
		add_index :scenes_users, [ :scene_id, :fb_user_id ], unique: true
	end
end