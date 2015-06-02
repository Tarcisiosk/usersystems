require 'test_helper'

class EmpresaTest < ActiveSupport::TestCase
  def test_empresa_valid
=begin
		emp1 = Empresa.new(:id => empresas(:one).id,
						:razao_social => empresas(:one).razao_social,
						:nome_fantasia => empresas(:one).nome_fantasia, 
						:cnpj => empresas(:one).cnpj)
		
		emp2 = Empresa.new(:id => empresas(:two).id,
						:razao_social => empresas(:two).razao_social,
						:nome_fantasia => empresas(:two).nome_fantasia, 
						:cnpj => empresas(:two).cnpj)
=end

		Empresa.all.each do |emp|
			assert emp.valid?, "Empresa: #{emp.nome_fantasia} não é valida, #{emp.errors.full_messages }"	
		end
	end

	def test_adm_id
		Empresa.all.each do |emp|
			assert emp.adm_id != nil, "Empresa #{emp.id} nao tem adm"	
		end
	end

	def test_uniqueness
		Empresa.all.each do |emp|
			Empresa.all.each do |empCompare|
				if emp != empCompare
					assert emp.cnpj != empCompare.cnpj, "Empresas #{emp.id} com cnpj iguais"
				end
			end
		end
	end

	def test_size
		Empresa.all.each  do |emp|
			assert emp.cnpj.length == 14, "Empresa #{emp.id} com cnpj com tamanho não correto"
		end
	end

	def test_presence
		Empresa.all.each do |emp|
			assert emp.razao_social.present?, "Empresa #{emp.id} sem razao social"
			assert emp.nome_fantasia.present?, "Empresa #{emp.id} sem nome fantasia"
			assert emp.cnpj.present?, "Empresa #{emp.id} sem cnpj"		
		end
	end
end
