require 'rails_helper'

RSpec.feature "Entidades", type: :feature, :js => true do

	scenario 'listar entidades' do					
		abro_pagina_as_adm 'entidades'
		consigo_ver 'EntidadeTeste'		
	end
=begin
	scenario 'adicionar entidade' do		
		abro_pagina_as_adm 'entidades'
		clico_link 'Novo'
		preencho_campo_com 'entidade[razao_social]', 'EntidadeTeste2'
		preencho_campo_com 'entidade[nome_fantasia]', 'EntidadeTeste2'
		preencho_campo_com 'entidade[cnpj]', '73573735737357'
		clico_botao 'Salvar'
		consigo_ver 'EntidadeTeste2' 
	end

	scenario 'editar entidade' do	
		@entidade = Entidade.find_by(razao_social: 'EntidadeTeste 2')
		abro_pagina_as_adm 'entidades'	
		clico_link 'Editar' + @entidade.id.to_s		
		preencho_campo_com 'entidade[razao_social]', 'EntidadeTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'EntidadeTeste 2'
	end
=end
end
