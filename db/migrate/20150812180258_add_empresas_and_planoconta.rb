class AddEmpresasAndPlanoconta < ActiveRecord::Migration
  def change
  	drop_table :empresas_planoconta if ActiveRecord::Base.connection.table_exists? 'empresas_planoconta'
  	create_table :empresas_planoconta do |t|
      t.references :empresa, :planoconta
    end
  end
end
