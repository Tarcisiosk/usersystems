class Movimentom < AbstractRecord
	TOTAL_COLUMNS_MOVIMENTOM = [{:sTitle => 'Data', :data_name => 'data', :bDefault => true}, 
						  	{:sTitle => 'Cliente', :data_name => 'entidade_id', :id=>'mov', :bDefault => true},
						  	{:sTitle => 'Valor', :data_name => 'totalvalor', :bDefault => true},
						  	{:sTitle => 'Quantidade', :data_name => 'totalquntidade', :bDefault => false}]

	validates :data, presence: true
	validates :entidade_id, presence: true
		  	
end
