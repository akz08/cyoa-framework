class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.integer :choice_id
  		t.string :text
  		t.integer :seconds_delay, default: 1
  	end
  end
end
