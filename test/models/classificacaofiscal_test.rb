require 'test_helper'

class ClassificacaofiscalTest < ActiveSupport::TestCase
    def test_classificacaofiscal_valid
		Classificacaofiscal.all.each do |clf|
			assert clf.valid?, "Classificação fiscal #{clf.id} não é valido, #{clf.errors.full_messages }"	
		end
	end

	def test_adm_id
		Classificacaofiscal.all.each do |clf|
			assert clf.adm_id != nil, "Classificação fiscal #{clf.id} não tem adm"	
		end
	end

	def test_presence
		Classificacaofiscal.all.each do |clf|
			assert clf.codigo_ncm.present?, "Classificação fiscal #{clf.id} sem código ncm"
			assert clf.descricao.present?, "Classificação fiscal #{clf.id} sem descrição"				
		end
	end
end
