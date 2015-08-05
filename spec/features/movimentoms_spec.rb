require 'rails_helper'

RSpec.feature "Movimentoms", type: :feature, :js => true do

	scenario 'listar movimentoms' do					
		abro_pagina 'movimentoms'
		consigo_ver 'Movimentos'		
	end

	scenario 'validar campos em branco do movimento' do
		abro_pagina 'movimentoms'
		clico_link 'Novo'
		clico_botao 'Salvar'
		consigo_ver	'Data não pode ficar em branco'
	end

	scenario 'adicionar movimento' do		
		abro_pagina 'movimentoms'
		clico_link 'Novo'
		preencho_campo_com 'data', '12/12/2012'
		clico_botao 'Salvar'
		consigo_ver '12/12/2012' 
	end

	scenario 'editar movimento' do	
		@mov = Movimentom.find_by(data: '12/12/2012')
		abro_pagina 'movimentoms'	
		clico_link 'Editar' + @mov.id.to_s		
		preencho_campo_com 'data', '21/12/2012'
		clico_botao 'Atualizar'
		consigo_ver '21/12/2012'
	end

	scenario 'deletar movimento' do
		@mov = Movimentom.find_by(data: '21/12/2012')
		abro_pagina 'movimentoms'
		clico_link 'Deletar'+ @mov.id.to_s
		clico_ok_alerta
		nao_consigo_ver '21/12/2012'
	end	

end