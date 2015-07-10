class Classificacaofiscal < AbstractRecord	 

	TOTAL_COLUMNS_CLASSIFICACAOFISCAL = [{:sTitle => 'Código NCM', :data_name => 'codigo_ncm', :bDefault => true},
										{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]

	has_many :icmsclassificacaofiscals, dependent: :destroy

	validates :codigo_ncm, presence: true
	validates :descricao, presence: true
	validates :pis_cst_id, presence: true
	validates :pis_aliquota, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true
	validates :cofins_cst_id, presence: true
	validates :cofins_aliquota, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true
	validates :ii_aliquota, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true
	validates :ipi_cst_id, presence: true
	validates :ipi_aliquota, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}, presence: true	

	before_save {
		self.versao = version_id_sequence												
	}	
end
 
 