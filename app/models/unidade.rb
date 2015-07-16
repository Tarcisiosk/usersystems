class Unidade < AbstractRecord

	TOTAL_COLUMNS_UNIDADE = [{:sTitle => 'Abreviação', :data_name => 'abreviacao', :bDefault => true}, 
						  {:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
					      {:sTitle => 'Fracionável', :data_name => 'fracionado', :bDefault => true}]

	has_and_belongs_to_many :empresas

	validates :abreviacao, presence: true, length: { in: 0..2 }
	validates :descricao, presence: true, length: { in: 0..100}
end
