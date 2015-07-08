class CreatePiscofinscsts < ActiveRecord::Migration
  def change
    create_table :piscofinscsts do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
