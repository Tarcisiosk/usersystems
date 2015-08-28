class CreateOrigems < ActiveRecord::Migration
  def change
    create_table :origems do |t|
      t.string :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
