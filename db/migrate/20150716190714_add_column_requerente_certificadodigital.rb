class AddColumnRequerenteCertificadodigital < ActiveRecord::Migration
  def change
  	remove_column :certificadodigitals, :remetente
  	add_column :certificadodigitals, :requerente, :string
  end
end
