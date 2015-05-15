class AdmToInt < ActiveRecord::Migration
  def change
  	tables = [:users, :empresas]
  	tables.each do |table_name|
  		remove_column table_name, :adm_id
  		add_column table_name, :adm_id, :integer, default: 1
  	end
  end
end
