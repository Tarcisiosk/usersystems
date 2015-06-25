class Estado < AbstractRecord
	TOTAL_COLUMNS_ESTADO = [{:sTitle => 'Código IBGE', :data_name => 'codigo_ibge', :bDefault => true},
							{:sTitle => 'UF', :data_name => 'uf', :bDefault => true},
						    {:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
							{:sTitle => 'ICMS Interno', :data_name => 'icms_interno', :bDefault => true},
							{:sTitle => 'Diferimento', :data_name => 'diferimento', :bDefault => true}]

	validates :codigo_ibge, presence: true, numericality: true
	validates :uf, presence: true, length: { in: 0..2 }
	validates :descricao, presence: true, length: { in: 0..50 }
	validates :icms_interno, presence: true 
	validates :diferimento, presence: true
end
