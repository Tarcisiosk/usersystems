class AddSuperSimplesEmpresa < ActiveRecord::Migration
  def change
  		add_column :empresas, :supersimples, :bool
  end
end
