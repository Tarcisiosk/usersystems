class CreateCertificadodigitals < ActiveRecord::Migration
  def change
    create_table :certificadodigitals do |t|
      t.integer :empresa_id
      t.string :cnpj
      t.string :senha
      t.date :inicio
      t.date :fim
      t.binary :imagem

      t.timestamps null: false
    end
  end
end
