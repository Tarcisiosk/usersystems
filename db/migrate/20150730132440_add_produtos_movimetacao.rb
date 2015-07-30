class AddProdutosMovimetacao < ActiveRecord::Migration
  def change
  	add_column :movimentoms, :produtos_list, :text
  end
end
