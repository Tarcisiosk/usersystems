class CreateCfops < ActiveRecord::Migration
  def change
    create_table :cfops do |t|
      t.string :codigo
      t.string :descricao
      t.boolean :devolucao

      t.timestamps null: false
    end
  end
end
