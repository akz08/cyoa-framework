class CreateChoices < ActiveRecord::Migration
  def change
  	create_table :choices do |t|
  		t.integer :parent_message_id, 	null: false
  		t.integer :child_message_id, 	null: false
  		t.string :text,					null: false
  		# to allow messages to point to another message
  		t.boolean :skip, 				default: false
  	end
  end

end
