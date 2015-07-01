require 'rails_helper'

RSpec.feature "Nivelacessos", type: :feature, :js => true do
  
   	scenario 'listar niveis acesso' do					
		abro_pagina 'nivelacesso'
		consigo_ver 'NivelTeste'		
	end

	scenario 'validar campos em branco do nivel acesso' do
		abro_pagina 'nivelacesso'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver	'Descricao não pode ficar em branco'
	end
	
	scenario 'adicionar nivel acesso' do		
		abro_pagina 'nivelacesso'
		clico_link 'Novo'
		preencho_campo_com 'nivelacesso[descricao]', 'NivelTeste2'
		clico_botao 'Gravar'
		consigo_ver 'NivelTeste2' 
	end

	scenario 'editar nivelacesso' do	
		@nivelacesso = Nivelacesso.find_by(descricao: 'NivelTeste2')
		abro_pagina 'nivelacesso'	
		clico_link 'Editar' + @nivelacesso.id.to_s		
		preencho_campo_com 'nivelacesso[descricao]', 'NivelTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'NivelTeste 2'
	end

	scenario 'deletar nivelacesso' do
		@nivelacesso = Nivelacesso.find_by(descricao: 'NivelTeste 2')
		abro_pagina 'nivelacesso'
		clico_link 'Deletar'+ @nivelacesso.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'NivelTeste 2'
	end	
end
