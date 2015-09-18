class AddGetAliqFromEmpresa < ActiveRecord::Migration
	def change
		add_column :produtos, :pisdaempresa, :bool
		add_column :produtos, :cofinsdaempresa, :bool
		add_column :classificacaofiscals, :pisdaempresa, :bool
		add_column :classificacaofiscals, :cofinsdaempresa, :bool
	end
end
