require 'test_helper'

class SubGrupoTest < ActiveSupport::TestCase
    def test_subgrupo_valid
=begin    	
		grp1 = Subgrupo.new(:id => subgrupos(:one).id,
						:descricao => subgrupos(:one).descricao,
						:grupo_id => subgrupos(:one).grupo_id,
						:adm_id => subgrupos(:one).adm_id)
		
		grp2 = Subgrupo.new(:id => subgrupos(:two).id,
						:descricao => subgrupos(:two).descricao,
						:grupo_id => subgrupos(:two).grupo_id,
						:adm_id => subgrupos(:two).adm_id)
=end	

		Subgrupo.all.each do |sgrp|
			assert sgrp.valid?, "SubGrupo: #{sgrp.id} não é valido, #{sgrp.errors.full_messages }"	
		end
	end

	def test_adm_id
		Subgrupo.all.each do |sgrp|
			assert sgrp.adm_id != nil, "SubGrupo #{sgrp.id} nao tem adm"	
		end
	end

	def test_presence
		Subgrupo.all.each do |sgrp|
			assert sgrp.descricao.present?, "SubGrupo #{sgrp.id} sem desrição"
			assert sgrp.grupo_id.present?, "SubGrupo #{sgrp.id} sem grupo"
		end
	end
end
