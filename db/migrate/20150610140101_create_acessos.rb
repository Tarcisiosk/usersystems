class CreateAcessos < ActiveRecord::Migration
  def change
    create_table :acessos do |t|
      t.string :modulo
      t.string :opcao
      t.string :acao
      t.string :descricao
      t.boolean :permissao

      t.timestamps null: false
    end
  end
end
