class CreateEntidades < ActiveRecord::Migration
  def change
    create_table :entidades do |t|
      t.string :razao_social
      t.string :nome_fantasia
      t.string :cnpj
      t.string :insc_estadual
      t.string :insc_municipal

      t.timestamps null: false
    end
  end
end
