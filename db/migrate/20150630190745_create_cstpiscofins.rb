class CreateCstpiscofins < ActiveRecord::Migration
  def change
    create_table :cstpiscofins do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end