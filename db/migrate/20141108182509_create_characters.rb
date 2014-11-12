class CreateCharacters < ActiveRecord::Migration
  def change
  	create_table :characters do |t|
  		t.string :char_id
  		t.string :name
  		t.integer :age
  		t.text :description
  	end
  end
end
