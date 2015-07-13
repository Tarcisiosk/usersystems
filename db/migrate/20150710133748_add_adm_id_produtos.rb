class AddAdmIdProdutos < ActiveRecord::Migration
  	def change
  		add_column :produtos, :adm_id, :integer
  	end
end
