class Subgrupo < AbstractRecord
	TOTAL_COLUMNS_SUBGRUPO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
							  {:sTitle => 'Grupo', :data_name => 'grupo_id', :bDefault => false}]

	has_and_belongs_to_many :empresas

	validates :descricao, presence: true, length: { in: 0..100 }
	validates :grupo_id, presence: true
end
