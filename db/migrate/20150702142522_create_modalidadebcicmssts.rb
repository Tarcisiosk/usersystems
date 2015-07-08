class CreateModalidadebcicmssts < ActiveRecord::Migration
  def change
    create_table :modalidadebcicmssts do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
