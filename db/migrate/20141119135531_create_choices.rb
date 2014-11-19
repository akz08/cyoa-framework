class CreateChoices < ActiveRecord::Migration
  def change
  	create_table :choices do |t|
  		t.integer :message_id
  		t.string :text
  	end
  end
end
