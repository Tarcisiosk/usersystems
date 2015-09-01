class AddAliqfcClasseProd < ActiveRecord::Migration
  def change
  	  add_column :icmsclassificacaofiscals, :aliquotafinscalculo, :float
  	  add_column :icmsprodutos, :aliquotafinscalculo, :float
  end
end
