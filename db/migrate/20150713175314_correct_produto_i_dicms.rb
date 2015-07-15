class CorrectProdutoIDicms < ActiveRecord::Migration
  def change
  	  	rename_column :icmsprodutos, :produtos_id, :produto_id

  end
end
