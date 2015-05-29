class Grupo < AbstractRecord
	TOTAL_COLUMNS_GRUPO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]

	validates :descricao, presence: true, length: { in: 0..100 }
	validates :adm_id, presence: true
end
