class CreateUnidades < ActiveRecord::Migration
  def change
    create_table :unidades do |t|
      t.string :abreviacao
      t.string :descricao
      t.integer :adm_id
      t.boolean :fracionado

      t.timestamps null: false
    end
  end
end
