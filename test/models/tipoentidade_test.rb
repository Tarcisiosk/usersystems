require 'test_helper'

class TipoentidadeTest < ActiveSupport::TestCase
  def test_grupo_valid
=begin	
		tpe1 = Grupo.new(:id => grupos(:one).id,
						:descricao => grupos(:one).descricao,
						:adm_id => grupos(:one).adm_id)
		
		tpe2 = Grupo.new(:id => grupos(:two).id,
						:descricao => grupos(:two).descricao,
						:adm_id => grupos(:two).adm_id)
=end

		Tipoentidade.all.each do |tpe|
			assert tpe.valid?, "Tipoentidade: #{tpe.id} não é valido, #{tpe.errors.full_messages }"	
		end
	end

	def test_adm_id
		Tipoentidade.all.each do |tpe|
			assert tpe.adm_id != nil, "Tipoentidade #{tpe.id} nao tem adm"	
		end
	end

	def test_presence
		Tipoentidade.all.each do |tpe|
			assert tpe.descricao.present?, "Tipoentidade #{tpe.id} sem desrição"
		end
	end

end
