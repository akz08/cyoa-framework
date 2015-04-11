class CreateUserHistory < ActiveRecord::Migration
	def change
		create_table :user_history do |t|
			t.integer :user_id,						null: false
			t.integer :message_id,					null: false
			t.integer :selected_choice_id,			null: false
			t.datetime :choice_selected_datetime,	null: false
		end
	end
end