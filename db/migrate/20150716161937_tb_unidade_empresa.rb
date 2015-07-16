class TbUnidadeEmpresa < ActiveRecord::Migration
  def change
  	create_table :empresas_unidades do |t|
    	t.references :empresa, :unidade
    end
  end
end
