class Movimentom < AbstractRecord
	TOTAL_COLUMNS_MOVIMENTOM = [{:sTitle => 'Data', :data_name => 'data', :bDefault => true}, 
						  	{:sTitle => 'Cliente', :data_name => 'entidade_id', :bDefault => true}]

	validates :data, presence: true
	validates :entidade_id, presence: true
		  	
end
