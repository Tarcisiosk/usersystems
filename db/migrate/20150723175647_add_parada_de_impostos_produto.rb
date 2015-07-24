class AddParadaDeImpostosProduto < ActiveRecord::Migration
  def change
	add_column :produtos, :pis_cst_id, :integer
  	add_column :produtos, :pis_aliquota, :float
  	add_column :produtos, :cofins_cst_id, :integer
  	add_column :produtos, :cofins_aliquota, :float
  	add_column :produtos, :ii_aliquota, :float
  	add_column :produtos, :ipi_cst_id, :integer
  	add_column :produtos, :ipi_aliquota, :float

  end
end
