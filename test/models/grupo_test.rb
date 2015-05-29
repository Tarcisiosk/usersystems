require 'test_helper'

class GrupoTest < ActiveSupport::TestCase
  def test_grupo_valid
		grp1 = Grupo.new(:id => grupos(:one).id,
						:descricao => grupos(:one).descricao,
						:adm_id => grupos(:one).adm_id)
		
		grp2 = Grupo.new(:id => grupos(:two).id,
						:descricao => grupos(:two).descricao,
						:adm_id => grupos(:two).adm_id)
		

		Grupo.all.each do |grp|
			assert grp.valid?, "Grupo: #{grp.id} não é valido, #{grp.errors.full_messages }"	
		end
	end

	def test_adm_id
		Grupo.all.each do |grp|
			assert grp.adm_id != nil, "Grupo #{grp.id} nao tem adm"	
		end
	end

	def test_presence
		Grupo.all.each do |grp|
			assert grp.descricao.present?, "Grupo #{grp.id} sem desrição"
		end
	end
end
