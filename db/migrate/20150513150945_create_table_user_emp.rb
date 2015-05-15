class CreateTableUserEmp < ActiveRecord::Migration
  def change
    create_table :user_empresas do |t|
    	t.integer "id_user"
    	t.integer "id_empresa"
    end
  end
end
