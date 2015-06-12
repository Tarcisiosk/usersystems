class CreateTipoentidades < ActiveRecord::Migration
  def change
    create_table :tipoentidades do |t|
      t.string :descricao

      t.timestamps null: false
    end
  end
end
