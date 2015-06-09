class Nivelacesso < AbstractRecord
	TOTAL_COLUMNS_NIVELACESSO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]
	validates :descricao, presence: true, length: { in: 0..30 }
	
	has_many :users

	has_settings do |s|
		s.key :acesso, :defaults => {:modulos => [[0, "Grupo", "Criar", "Permite a criação", false], [1, "Grupo", "Editar", "Permite a edição", false], [2, "Grupo", "Deletar", "Permite a exclusão", false],
												 [3, "Sub-Grupo", "Criar", "Permite a criação", false], [4, "Sub-Grupo", "Editar", "Permite a edição", false], [5, "Sub-Grupo", "Deletar", "Permite a exclusão", false],
												 [6, "Empresa", "Criar", "Permite a criação", false], [7, "Empresa", "Editar", "Permite a edição", false], 
												 [8, "Usuário", "Criar", "Permite a criação", false], [9, "Usuário", "Editar", "Permite a edição", false],  [10, "Usuário", "Deletar", "Permite a exclusão", false]]}
	
	end
end
