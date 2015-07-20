require 'rails_helper'

RSpec.feature "Tipomovimentacaos", type: :feature, :js => true do
    scenario 'listar tipo de movimentacoes' do					
		abro_pagina_as_adm 'tipomovimentacaos'		
		consigo_ver 'Tipo de Movimentações'		
	end	
	scenario 'validar campos do tipo movimentacao' do
		abro_pagina_as_adm 'tipomovimentacaos'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Descricao não pode ficar em branco
					Tipo não pode ficar em branco'
	end
	scenario 'adicionar tipo movimentacao' do
		abro_pagina_as_adm 'tipomovimentacaos'
		clico_link 'Novo'
		preencho_campo_com 'descricao', 'TP1'
		seleciono_opcao_do '1 - Entrada', 'tipo'	
		clico_botao 'Gravar'
		consigo_ver 'TP1'
	end
	scenario 'editar tipo movimentacao' do
		@tipomovimentacao = Tipomovimentacao.find_by(descricao: 'TP1')
		abro_pagina_as_adm 'tipomovimentacaos'	
		clico_link 'Editar' + @tipomovimentacao.id.to_s		
		preencho_campo_com 'descricao', 'TP2'
		clico_botao 'Gravar'
		consigo_ver 'TP2' 
	end
	scenario 'deletar tipo movimentacao' do 
		@tipomovimentacao = Tipomovimentacao.find_by(descricao: 'TP2')
		abro_pagina_as_adm 'tipomovimentacaos'
		clico_link 'Deletar'+@tipomovimentacao.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'TP2'
	end	
end
