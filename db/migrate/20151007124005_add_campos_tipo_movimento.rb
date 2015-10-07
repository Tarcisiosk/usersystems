class AddCamposTipoMovimento < ActiveRecord::Migration
  def change
	add_column :tipomovimentacaos, :incide_ipi, :bool, :default => true
	add_column :tipomovimentacaos, :incide_icms, :bool, :default => true
	add_column :tipomovimentacaos, :incide_piscofins, :bool, :default => true
  end
end
