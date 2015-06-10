class Nivelacesso < AbstractRecord
	TOTAL_COLUMNS_NIVELACESSO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]
	validates :descricao, presence: true, length: { in: 0..30 }
	
	has_many :users
	has_and_belongs_to_many :acessos

end
