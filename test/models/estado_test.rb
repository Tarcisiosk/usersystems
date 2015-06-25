require 'test_helper'

class EstadoTest < ActiveSupport::TestCase
    def test_estado_valid
		Estado.all.each do |est|
			assert est.valid?, "Estado: #{est.descricao} não é valido, #{est.errors.full_messages }"	
		end
	end

	def test_size
		Estado.all.each  do |est|
			assert est.uf.length == 2, "Estado #{est.id} com uf com tamanho não correto"			
		end
	end

	def test_presence
		Estado.all.each do |est|
			assert est.codigo_ibge.present?, "Estado #{est.id} sem código ibge"
			assert est.uf.present?, "Estado #{est.id} sem uf"
			assert est.descricao.present?, "Empresa #{est.id} sem descricao"
			assert est.icms_interno.present?, "Estado #{est.id} sem icms_interno"
			assert est.diferimento.present?, "Estado #{est.id} sem diferimento"		
		end
	end
end
