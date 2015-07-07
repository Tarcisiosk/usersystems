require 'rails_helper'

RSpec.feature "Estados", type: :feature, :js => true do
    scenario 'listar estados' do					
		abro_pagina 'estados'
		consigo_ver 'Acre'		
	end
	scenario 'validar campos em branco do estado' do
		abro_pagina 'estados'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Codigo ibge não pode ficar em branco'					 					 
		consigo_ver	'Uf não pode ficar em branco'
		consigo_ver	'Descricao não pode ficar em branco'
		consigo_ver	'Icms interno não pode ficar em branco'
		consigo_ver	'Diferimento não pode ficar em branco'
	end
	scenario 'validar tamanhos dos campos do estado' do
		abro_pagina 'estados'
		clico_link 'Novo'
		preencho_campo_com 'estado[uf]', 'XXXX'
		preencho_campo_com 'estado[descricao]', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
												 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
		clico_botao 'Gravar'
		consigo_ver 'Uf é muito longo (máximo: 2 caracteres)'
		consigo_ver	'Descricao é muito longo (máximo: 50 caracteres)'					 
	end		
	scenario 'adicionar estado' do		
		abro_pagina 'estados'
		clico_link 'Novo'
		preencho_campo_com 'estado[codigo_ibge]', '33'
		preencho_campo_com 'estado[uf]', 'RJ'
		preencho_campo_com 'estado[descricao]', 'Rio de Janeiro'
		preencho_campo_com 'estado[icms_interno]', '15'
		preencho_campo_com 'estado[diferimento]', '12'
		clico_botao 'Gravar'
		consigo_ver 'Rio de Janeiro' 
	end
	scenario 'editar estado' do	
		@estado = Estado.find_by(descricao: 'Rio de Janeiro')
		abro_pagina 'estados'	
		clico_link 'Editar' + @estado.id.to_s		
		preencho_campo_com 'estado[uf]', 'XX'
		clico_botao 'Atualizar'
		consigo_ver 'XX'
	end
	scenario 'deletar estado' do
		@estado = Estado.find_by(descricao: 'Rio de Janeiro')
		abro_pagina 'estados'
		clico_link 'Deletar'+@estado.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'Rio de Janeiro'
	end	
end