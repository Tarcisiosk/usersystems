class CreatePlanoconta < ActiveRecord::Migration
  def change
    create_table :planoconta do |t|
      t.string :codigo
      t.string :descricao
      t.integer :planoconta_id
      t.integer :adm_id

      t.timestamps null: false
    end
  end
end
