class AddCidadeToEmpresas < ActiveRecord::Migration
  def change
  	remove_column :empresas, :endereco
  	add_column :empresas, :cidade, :string
  end
end
