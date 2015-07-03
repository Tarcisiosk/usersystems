class AddTipotoEndereco < ActiveRecord::Migration
  def change

  	create_table :empresas_grupos do |t|
    	t.references :empresa, :grupo
    end

    create_table :empresas_subgrupos do |t|
    	t.references :empresa, :subgrupo
    end
    
    add_column :enderecos, :tipo_endereco, :string

  end
end
