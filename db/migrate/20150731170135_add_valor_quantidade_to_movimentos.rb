class AddValorQuantidadeToMovimentos < ActiveRecord::Migration
  def change
  	add_column :movimentoms, :totalquantidade, :float
  	add_column :movimentoms, :totalvalor, :float
  end
end
