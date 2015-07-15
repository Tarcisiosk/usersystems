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

	def cnpj_is_valid
	  cnpj_valid(cnpj) 	
	end

	def cnpj_valid(str)
		#cpf / #cnpj
		if str.length == 11
			
			str_array = str.split(//).map { |s| s.to_i }
						
			digitoverificador = str_array.pop(2)
			
			somatorio = 0
			str_array.each_with_index do |num, index|
				somatorio += num * (10 - index)
			end

			resto = somatorio % 11

			digito_um = 11 - resto

			if digito_um > 9
				digito_um = 0
			end

			somatorio = 0
			str_array << digito_um
			str_array.each_with_index do |num, index|
				somatorio += num * (11 - index)
			end

			resto = somatorio % 11

			digito_dois = 11 - resto
			
			if digito_dois > 9
				digito_dois = 0
			end

			digito_final = (digito_um.to_s + digito_dois.to_s).to_i
			
			if digitoverificador.join("").to_i == digito_final
				puts "CPF VALIDO!"
				return true
			else
				puts "CPF INVALIDO!"
				errors.add(:cnpj, "/ Cpf não é válido")
				return false
			end

		elsif str.length == 14

			str_array = str.split(//).map { |s| s.to_i }
						
			digitoverificador = str_array.pop(2)

			somatorio = 0
			aux = 5
			str_array.each_with_index do |num, index|
			
				somatorio += num * aux
				aux -= 1
				if aux < 2
					aux = 9
				end
				#puts "***************** SOMATORIO: #{ somatorio } = #{num} * #{aux}"

			end
			
			resto = somatorio % 11

			if resto < 2
				digito_um = 0
			else
				digito_um = 11 - resto
			end

			str_array = str_array << digito_um

			somatorio = 0
			aux = 6

			str_array.each_with_index do |num, index|
			
				somatorio += num * aux
				aux -= 1
				if aux < 2
					aux = 9
				end
			end

			resto = somatorio % 11

			if resto < 2
				digito_dois = 0
			else
				digito_dois = 11 - resto
			end


			digito_final = (digito_um.to_s + digito_dois.to_s).to_i

			if digitoverificador.join("").to_i == digito_final
				puts "CPF VALIDO!"
				return true
			else
				puts "CPF INVALIDO!"
				errors.add(:cnpj, "/ Cpf não é válido")
				return false
			end
		else
			errors.add(:cnpj, "/ Cpf não é válido")
		end

	end

	has_and_belongs_to_many :tipoentidades
  	has_and_belongs_to_many :empresas
  	
  	has_many :enderecos, :dependent => :destroy

  	before_save {self.cnpj = cnpj.gsub(/<\/?[^>]*>/, '')}

	validates :razao_social, presence: true, length: { in: 0..60 }
	validates :nome_fantasia, presence: true, length: { in: 0..60 }
	validates :cnpj, presence: true
	validates :cnpj, numericality: true,  length: { in: 11..14 }, :if => :cnpj_is_filled
	validates :cnpj, uniqueness: true, :if => :cnpj_is_valid
	validates :insc_estadual, numericality: true, uniqueness: true, length: { in: 0..20}, :allow_blank => true
	validates :insc_municipal, numericality: true, uniqueness: true, length: { in: 0..20 }, :allow_blank => true
	validates :email, email:true, :allow_blank => true
	#validates :telefone, presence: false, numericality: true, length: { in: 11..11 }
	#validates :celular, presence: false, numericality: true, length: { in: 11..11 }

end
