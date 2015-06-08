class Nivelacesso < AbstractRecord
	TOTAL_COLUMNS_NIVELACESSO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]
	validates :descricao, presence: true, length: { in: 0..30 }
	
	has_settings do |s|
		s.key :acesso, :defaults => {:modulos => {:grupo => [["Grupo", "Editar", "Permite a edição", false],
												 			["Grupo", "Deletar", "Permite a exclusão", false]],
												 :subgrupo =>[["Sub-Grupo", "Editar", "Permite a edição", false],
												 			  ["Sub-Grupo", "Deletar", "Permite a exclusão", false]]}}
	end
	
	belongs_to :users
end
