class AddColumnRemetenteCertificadodigital < ActiveRecord::Migration
  def change
  	add_column :certificadodigitals, :remetente, :string
  end
end
