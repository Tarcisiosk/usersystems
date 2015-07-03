class Grupo < AbstractRecord
	TOTAL_COLUMNS_GRUPO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]
	
	has_and_belongs_to_many :empresas

	validates :descricao, presence: true, length: { in: 0..100 }

end
