class AddPisConfinsEmpresa < ActiveRecord::Migration
	def change
		add_column :empresas, :aliquotapis, :float
		add_column :empresas, :aliquotaconfins, :float
	end
end
