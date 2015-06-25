class CreateConfiguracaofiscals < ActiveRecord::Migration
  def change
    create_table :configuracaofiscals do |t|
      t.integer :codigo_ncm
      t.string :descricao
      t.integer :adm_id
      t.integer :versao

      t.timestamps null: false
    end
  end
end
