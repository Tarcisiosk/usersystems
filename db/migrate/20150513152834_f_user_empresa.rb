class FUserEmpresa < ActiveRecord::Migration
  def change
  	drop_table :user_empresas
  	create_table :users_empresas do |t|
    	t.references :user, :empresa
    end
  end
end
