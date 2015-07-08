class ChangeColumnTypeCodigosNcmExClassificacaofiscal < ActiveRecord::Migration
  def change
  	change_column :classificacaofiscals, :codigo_ncm, :string
  	change_column :classificacaofiscals, :codigo_ex, :string
  end
end
