class RenameTable < ActiveRecord::Migration
  def change
  	rename_table :users_empresas, :empresas_users
  end
end
