class CreateSubGrupos < ActiveRecord::Migration
  def change
    create_table :sub_grupos do |t|
      t.text :descricao
      t.integer :grupo_id
      t.integer :adm_id

      t.timestamps null: false
    end
  end
end
