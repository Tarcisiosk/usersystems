class CreateIcmsclassificacaofiscals < ActiveRecord::Migration
  def change
    create_table :icmsclassificacaofiscals do |t|
      t.integer :classificacaofiscal_id
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
