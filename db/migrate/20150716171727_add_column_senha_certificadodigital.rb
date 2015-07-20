class AddColumnSenhaCertificadodigital < ActiveRecord::Migration
  def change
  	add_column :certificadodigitals, :senha, :string
  end
end
