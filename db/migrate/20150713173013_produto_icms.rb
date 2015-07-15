class ProdutoIcms < ActiveRecord::Migration
  def change
  	 create_table :icmsprodutos do |t|
      t.integer :produtos_id
      t.integer :estado_id
      t.float :reducaobasecalculo
      t.float :diferimento
      t.float :aliquota
      t.boolean :icmsst
      t.integer :modalidadebcicmsst_id
      t.float :mva
      t.boolean :reducaomva

      t.timestamps null: false
    end
  end
end
