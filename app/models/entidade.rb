class EmailValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
				record.errors[attribute] << (options[:message] || "não é um email")
		end
	end
end

class Entidade < AbstractRecord
	TOTAL_COLUMNS_ENTIDADE = [{:sTitle => 'Razão Social', :data_name => 'razao_social', :bDefault => true}, 
							 {:sTitle => 'Nome Fantasia', :data_name => 'nome_fantasia', :bDefault => true},
							 {:sTitle => 'CNPJ/CPF', :data_name => 'cnpj', :bDefault => true},
							 {:sTitle => 'Insc. Estadual', :data_name => 'insc_estadual', :bDefault => false},
							 {:sTitle => 'Insc. Municipal', :data_name => 'insc_municipal', :bDefault => false}]

	def cnpj_is_filled 
	  !cnpj.blank? 	
	end 
	has_and_belongs_to_many :tipoentidades
  	has_and_belongs_to_many :empresas
  	
  	has_many :enderecos, :dependent => :destroy

  	before_save {self.cnpj = cnpj.gsub(/<\/?[^>]*>/, '')}

	validates :razao_social, presence: true, length: { in: 0..60 }
	validates :nome_fantasia, presence: true, length: { in: 0..60 }
	validates :cnpj, presence: true
	validates :cnpj, numericality: true, uniqueness: true, length: { in: 11..14 }, :if => :cnpj_is_filled
	validates :insc_estadual, numericality: true, uniqueness: true, length: { in: 0..20}, :allow_blank => true
	validates :insc_municipal, numericality: true, uniqueness: true, length: { in: 0..20 }, :allow_blank => true
	#validates :email, presence: false, email:true
	#validates :telefone, presence: false, numericality: true, length: { in: 11..11 }
	#validates :celular, presence: false, numericality: true, length: { in: 11..11 }

end
