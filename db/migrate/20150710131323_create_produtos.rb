class CreateProdutos < ActiveRecord::Migration
  def change
    create_table :produtos do |t|
      t.string :descricao
      t.string :codigo
      t.float :preco
      t.string :unidade

      t.timestamps null: false
    end
  end
end
