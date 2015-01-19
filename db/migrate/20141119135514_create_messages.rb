class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.integer :scene_id,		null: false
  		t.string :text,				null: false
  		t.integer :seconds_delay, 	default: 1
  	end
  end
end
