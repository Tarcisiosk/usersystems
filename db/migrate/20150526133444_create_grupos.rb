class CreateGrupos < ActiveRecord::Migration
  def change
    create_table :grupos do |t|
      t.text :descricao
      t.integer :adm_id

      t.timestamps null: false
    end
  end
end
