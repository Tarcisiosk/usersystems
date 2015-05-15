class AdmIDtoTAbles < ActiveRecord::Migration
  def change
  	tables = [:users, :empresas]
  	tables.each do |table_name|
   		add_column table_name, :adm_id, :string
  	end
  end
end
