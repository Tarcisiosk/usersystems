class RemoveColumnSenhaCertificadodigital < ActiveRecord::Migration
  def change
  	remove_column :certificadodigitals, :senha
  end
end
