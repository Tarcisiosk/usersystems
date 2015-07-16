class Cfop < AbstractRecord
	TOTAL_COLUMNS_CFOP = [{:sTitle => 'CFOP', :data_name => 'codigo', :bDefault => true}, 
						  {:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
					      {:sTitle => 'Devolução', :data_name => 'devolucao', :bDefault => true}]

	validates :codigo, presence: true, length: { in: 4..4 }
	validates :descricao, presence: true, length: { in: 0..200}

end
