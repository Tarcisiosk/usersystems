class Entidade < AbstractRecord
	TOTAL_COLUMNS_ENTIDADE = [{:sTitle => 'Razão Social', :data_name => 'razao_social', :bDefault => true}, 
							 {:sTitle => 'Nome Fantasia', :data_name => 'nome_fantasia', :bDefault => true},
							 {:sTitle => 'CNPJ', :data_name => 'cnpj', :bDefault => true},
							 {:sTitle => 'Insc. Estadual', :data_name => 'insc_estadual', :bDefault => false},
							 {:sTitle => 'Insc. Municipal', :data_name => 'insc_municipal', :bDefault => false}]

	def cnpj_is_filled 
	  !cnpj.blank? 	
	end 

  	before_save {self.cnpj = cnpj.gsub(/<\/?[^>]*>/, '')}

	validates :razao_social, presence: true, length: { in: 0..60 }
	validates :nome_fantasia, presence: true, length: { in: 0..60 }
	validates :cnpj, presence: true
	validates :cnpj, numericality: true, uniqueness: true, length: { in: 14..14 }, :if => :cnpj_is_filled
	validates :insc_estadual, numericality: true, uniqueness: true, length: { in: 0..20}, :allow_blank => true
	validates :insc_municipal, numericality: true, uniqueness: true, length: { in: 0..20 }, :allow_blank => true
end
