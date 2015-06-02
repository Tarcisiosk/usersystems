require 'test_helper'

class NivelacessoTest < ActiveSupport::TestCase
  def test_nivelacesso_valid
=begin		
		niv1 = Nivelacesso.new(:id => nivelacessos(:one).id,
						:descricao => nivelacessos(:one).descricao,
						:adm_id => nivelacessos(:one).adm_id)
		
		niv2 = Nivelacesso.new(:id => nivelacessos(:two).id,
						:descricao => nivelacessos(:two).descricao,
						:adm_id => nivelacessos(:two).adm_id)
		
=end
		Nivelacesso.all.each do |niv|
			assert niv.valid?, "Nivel acesso: #{niv.id} não é valido, #{niv.errors.full_messages }"	
		end
	end

	def test_adm_id
		Nivelacesso.all.each do |niv|
			assert niv.adm_id != nil, "Nivel acesso #{niv.id} nao tem adm"	
		end
	end

	def test_presence
		Nivelacesso.all.each do |niv|
			assert niv.descricao.present?, "Nivel acesso #{niv.id} sem desrição"
		end
	end
end
