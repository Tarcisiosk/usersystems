class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.integer :serie
      t.integer :modelo
      t.integer :ultima_nota_fiscal
      t.integer :ambiente
      t.references :empresa, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
