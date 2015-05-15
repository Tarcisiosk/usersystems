class AddColumnToEmpresas < ActiveRecord::Migration
  def change
  	add_column :empresas, :rua, :string
  	add_column :empresas, :num_rua, :string
  	add_column :empresas, :complemento, :string
  	add_column :empresas, :bairro, :string
  	add_column :empresas, :uf, :string
  	add_column :empresas, :cep, :string
  end
end
