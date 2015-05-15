class Adjustments < ActiveRecord::Migration
  def change
  	tables = [:users, :empresas]
  	tables.each do |table_name|
  		change_column table_name, :adm_id, :string, default: 1
  	end
  	drop_table :AbstractRecord
  	drop_table :conf_telas
  end
end
