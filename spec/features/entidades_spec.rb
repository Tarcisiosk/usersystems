require 'rails_helper'

RSpec.feature "Entidades", type: :feature, :js => true do

	scenario 'listar entidades' do					
		abro_pagina_as_adm 'entidades'
		consigo_ver 'EMPRESAS/CONTATOS'		
	end

	scenario 'validar campos em branco da entidade' do
		abro_pagina_as_adm 'entidades'
		clico_link 'Novo'
		marco_checkbox 'tipo2'
		clico_botao 'Salvar'
		consigo_ver	'Razao social não pode ficar em branco'
		consigo_ver	'Nome fantasia não pode ficar em branco'
		consigo_ver	'Cnpj não pode ficar em branco'
	end

	scenario 'adicionar entidade' do		
		abro_pagina_as_adm 'entidades'
		clico_link 'Novo'
		marco_checkbox 'tipo2'
		preencho_campo_com 'razao_social', 'EntidadeTeste2'
		preencho_campo_com 'nome_fantasia', 'EntidadeTeste2'
		preencho_campo_com 'cnpj', '70413361000145'
		clico_botao 'Salvar'
		consigo_ver 'EntidadeTeste2' 
	end

	scenario 'editar entidade' do	
		@entidade = Entidade.find_by(razao_social: 'EntidadeTeste2')
		abro_pagina_as_adm 'entidades'	
		clico_link 'Editar' + @entidade.id.to_s		
		preencho_campo_com 'razao_social', 'EntidadeTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'EntidadeTeste 2'
	end

	scenario 'deletar entidade' do
		@entidade = Entidade.find_by(razao_social: 'EntidadeTeste 2')
		abro_pagina_as_adm 'entidades'
		clico_link 'Deletar'+ @entidade.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'EntidadeTeste 2'
	end	

end
