class CreateNivelacessos < ActiveRecord::Migration
  def change
    create_table :nivelacessos do |t|
      t.string :descricao
      t.integer :adm_id

      t.timestamps null: false
    end
  end
end
