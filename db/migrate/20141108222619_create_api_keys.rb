class CreateApiKeys < ActiveRecord::Migration
  def change
  	create_table :api_keys do |t|
  		t.string :access_token,		null: false
  		t.integer :uid,	:limit => 8, null: false
  		t.boolean :active, 			null: false, default: true

  		t.timestamps
  	end

  	add_index :api_keys, ['uid'], unique: false
  	add_index :api_keys, ['access_token'], unique: true
  end
end
