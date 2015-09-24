class AddStatusEmTudo < ActiveRecord::Migration

	tables = [:cfops, :classificacaofiscals, :contacorrentes, :empresas, :entidades,
			 :estados, :grupos, :movimentoms, :nivelacessos, :planoconta, :produtos,
			 :series, :tipoentidades, :tipomovimentacaos, :unidades, :users]

	tables.each do |table_name|
    	add_column table_name, :status, :string, :default => 'a'
    	add_column table_name, :usuarioalterador, :string
	  	add_column table_name, :dataalteracao, :datetime
	end
end
