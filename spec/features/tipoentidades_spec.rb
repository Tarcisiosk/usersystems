require 'rails_helper'

RSpec.feature "Tipoentidades", type: :feature, :js => true do
  	scenario 'listar tipos' do					
		abro_pagina_as_adm 'tipoentidades'
	end
	
	scenario 'validar campos em branco do tipoentidade' do
		abro_pagina_as_adm 'tipoentidades'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver	'Descricao não pode ficar em branco'
	end
	
	scenario 'adicionar tipoentidade' do		
		abro_pagina_as_adm 'tipoentidades'
		clico_link 'Novo'
		preencho_campo_com 'tipoentidade[descricao]', 'TipoTeste2'
		clico_botao 'Gravar'
		consigo_ver 'TipoTeste2' 
	end

	scenario 'editar tipoentidade' do	
		@tipoentidade = Tipoentidade.find_by(descricao: 'TipoTeste2')
		abro_pagina_as_adm 'tipoentidades'	
		clico_link 'Editar' + @tipoentidade.id.to_s		
		preencho_campo_com 'tipoentidade[descricao]', 'TipoTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'TipoTeste 2'
	end
	
	scenario 'deletar tipoentidade' do
		@tipoentidade = Tipoentidade.find_by(descricao: 'TipoTeste 2')
		abro_pagina_as_adm 'tipoentidades'
		clico_link 'Deletar'+ @tipoentidade.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'TipoTeste 2'
	end	
end
