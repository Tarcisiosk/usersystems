class Empresa < AbstractRecord

	TOTAL_COLUMNS_EMPRESA = [{:sTitle => 'Razão Social', :data_name => 'razao_social', :bDefault => true}, 
							 {:sTitle => 'Nome Fantasia', :data_name => 'nome_fantasia', :bDefault => true},
							 {:sTitle => 'CNPJ', :data_name => 'cnpj', :bDefault => true},
							 {:sTitle => 'Insc. Estadual', :data_name => 'insc_estadual', :bDefault => false},
							 {:sTitle => 'Insc. Municipal', :data_name => 'insc_municipal', :bDefault => false},
							 {:sTitle => 'Bairro', :data_name => 'bairro', :bDefault => false},
							 {:sTitle => 'UF', :data_name => 'uf', :bDefault => false},
							 {:sTitle => 'CEP', :data_name => 'cep', :bDefault => false},
						     {:sTitle => 'ADM', :data_name => 'adm_id', :bDefault => false}]
  	
  	has_and_belongs_to_many :users

	validates :razao_social, presence: true, length: { in: 0..60 }
	validates :nome_fantasia, presence: true, length: { in: 0..60 }
	validates :cnpj, presence: true, numericality: true, uniqueness: true, length: { in: 10..14 }
	validates :insc_estadual, presence: true, numericality: true, uniqueness: true, length: { in: 0..20}
	validates :insc_municipal, presence: true, numericality: true, uniqueness: true, length: { in: 0..20 }
	validates :endereco, presence: true, length: { in: 0..100 }

end
