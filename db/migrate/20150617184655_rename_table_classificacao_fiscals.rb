class RenameTableClassificacaoFiscals < ActiveRecord::Migration
  def change
  	rename_table :configuracaofiscals, :classificacaofiscals
  end
end
