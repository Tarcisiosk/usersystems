require 'rails_helper'

RSpec.feature "Subgrupos", type: :feature, :js => true do
	
	scenario 'listar subgrupo' do					
		abro_pagina 'subgrupos'
		consigo_ver 'Sub-Grupos'		
	end

	scenario 'validar campos em branco do subgrupo' do
		abro_pagina 'subgrupos'
		clico_link 'Novo'
		clico_botao 'Salvar'
		consigo_ver	'Descricao não pode ficar em branco'
	end
	
	scenario 'adicionar subgrupo' do		
		abro_pagina 'subgrupos'
		clico_link 'Novo'
		preencho_campo_com 'descricao', 'SubGrupoTeste2'
		clico_botao 'Salvar'
		consigo_ver 'SubGrupoTeste2' 
	end

	scenario 'editar subgrupo' do	
		@subgrupo = Subgrupo.find_by(descricao: 'SubGrupoTeste2')
		abro_pagina 'subgrupos'	
		clico_link 'Editar' + @subgrupo.id.to_s		
		preencho_campo_com 'descricao', 'SubGrupoTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'SubGrupoTeste 2'
	end
	
	scenario 'deletar grupo' do
		@subgrupo = Subgrupo.find_by(descricao: 'SubGrupoTeste 2')
		abro_pagina 'subgrupos'
		clico_link 'Deletar'+ @subgrupo.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'SubGrupoTeste 2'
	end	
	
end
