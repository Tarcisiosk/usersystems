class CreateTipomovimentacaos < ActiveRecord::Migration
  def change
    create_table :tipomovimentacaos do |t|
      t.string :descricao
      t.string :tipo
      t.integer :adm_id

      t.timestamps null: false
    end
  end
end
