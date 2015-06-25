class Classificacaofiscal < AbstractRecord
	TOTAL_COLUMNS_CLASSIFICACAOFISCAL = [{:sTitle => 'Código NCM', :data_name => 'codigo_ncm', :bDefault => true},
										{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
										{:sTitle => 'Versão', :data_name => 'versao', :bDefault => true},
										{:sTitle => 'ADM ID', :data_name => 'adm_id', :bDefault => true}]

	validates :codigo_ncm, presence: true
	validates :descricao, presence: true

	before_update {
		self.versao = version_id_sequence
		puts "versao #{self.versao}"										
	}	
end
 
 