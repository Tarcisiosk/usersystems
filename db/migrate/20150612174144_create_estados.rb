class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.integer :codigo_ibge
      t.string :uf, limit: 2
      t.string :descricao, limit: 50
      t.float :icms_interno
      t.float :diferimento

      t.timestamps null: false
    end
  end
end
