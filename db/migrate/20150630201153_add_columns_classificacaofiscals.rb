class AddColumnsClassificacaofiscals < ActiveRecord::Migration
  def change
  	add_column :classificacaofiscals, :codigo_ex, :integer
  	add_column :classificacaofiscals, :pis_cst_id, :integer
  	add_column :classificacaofiscals, :pis_aliquota, :float
  	add_column :classificacaofiscals, :cofins_cst_id, :integer
  	add_column :classificacaofiscals, :cofins_aliquota, :float
  	add_column :classificacaofiscals, :ii_aliquota, :float
  	add_column :classificacaofiscals, :ipi_cst_id, :integer
  	add_column :classificacaofiscals, :ipi_aliquota, :float
  end
end
