class DropTableEmpresasAndPlanoconta < ActiveRecord::Migration
  def change
  	drop_table :empresas_planoconta if ActiveRecord::Base.connection.table_exists? 'empresas_planoconta'
  end
end
