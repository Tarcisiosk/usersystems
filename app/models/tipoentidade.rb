class Tipoentidade < AbstractRecord
	TOTAL_COLUMNS_TIPOENTIDADE = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]
	validates :descricao, presence: true, length: { in: 0..100 }

	has_and_belongs_to_many :entidades
end
