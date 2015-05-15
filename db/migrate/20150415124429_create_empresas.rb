class CreateEmpresas < ActiveRecord::Migration
  def change
    create_table :empresas do |t|
      t.string :razao_social
      t.string :nome_fantasia
      t.string :cnpj
      t.string :insc_estadual
      t.string :insc_municipal
      t.string :endereco
      t.timestamps null: false

      t.string :owner
      t.references :users, index: true
    end

    add_foreign_key :empresas, :users
  end
end
