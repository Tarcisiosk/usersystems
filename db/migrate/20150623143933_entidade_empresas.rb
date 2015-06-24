class EntidadeEmpresas < ActiveRecord::Migration
  def change
  	create_table :empresas_entidades do |t|
    	t.references :empresa, :entidade
    end

    create_table :entidades_tipoentidades do |t|
    	t.references :entidade, :tipoentidade
    end
  end
end
