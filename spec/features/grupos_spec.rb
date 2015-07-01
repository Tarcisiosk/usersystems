require 'rails_helper'

RSpec.feature "Grupos", type: :feature, :js => true do
   
    scenario 'listar grupos' do					
		abro_pagina 'grupos'
		consigo_ver 'GrupoTeste'		
	end
	
	scenario 'validar campos em branco do grupo' do
		abro_pagina 'grupos'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver	'Descricao não pode ficar em branco'
	end
	
	scenario 'adicionar grupo' do		
		abro_pagina 'grupos'
		clico_link 'Novo'
		preencho_campo_com 'grupo[descricao]', 'GrupoTeste2'
		clico_botao 'Gravar'
		consigo_ver 'GrupoTeste2' 
	end

	scenario 'editar grupo' do	
		@grupo = Grupo.find_by(descricao: 'GrupoTeste2')
		abro_pagina 'grupos'	
		clico_link 'Editar' + @grupo.id.to_s		
		preencho_campo_com 'grupo[descricao]', 'GrupoTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'GrupoTeste 2'
	end
	
	scenario 'deletar grupo' do
		@grupo = Grupo.find_by(descricao: 'GrupoTeste 2')
		abro_pagina 'grupos'
		clico_link 'Deletar'+ @grupo.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'GrupoTeste 2'
	end	
end
