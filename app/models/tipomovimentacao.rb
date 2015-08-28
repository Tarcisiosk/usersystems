class Tipomovimentacao < AbstractRecord
	TOTAL_COLUMNS_TIPOMOVIMENTACAO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
							  {:sTitle => 'Tipo', :data_name => 'tipo', :bDefault => true}]

	belongs_to :empresa, dependent: :destroy
							  
	validates :descricao, presence: true
	validates :tipo, presence: true
end
