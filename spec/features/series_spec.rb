require 'rails_helper'

RSpec.feature "Series", type: :feature, :js => true do
  	scenario 'listar séries' do					
		abro_pagina_as_adm 'series'		
		consigo_ver 'SÉRIES'		
	end	
	scenario 'validar campos da série' do
		abro_pagina_as_adm 'series'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Serie não pode ficar em branco
					Serie deve ter um valor numérico
					Modelo não pode ficar em branco
					Ultima nota fiscal não pode ficar em branco
					Ultima nota fiscal deve ter um valor numérico
					Ambiente não pode ficar em branco'
	end
	scenario 'adicionar série' do
		abro_pagina_as_adm 'series'
		clico_link 'Novo'
		preencho_campo_com 'serie', '777'
		seleciono_opcao_do '55 - Nota Fiscal Eletrônica', 'modelo'
		preencho_campo_com 'ultima_nota_fiscal', '1' 
		seleciono_opcao_do '1 - Produção', 'ambiente'
		clico_botao 'Gravar'
		consigo_ver '777'
	end
	scenario 'editar série' do
		@serie = Serie.find_by(serie: '777')
		abro_pagina_as_adm 'series'	
		clico_link 'Editar' + @serie.id.to_s		
		preencho_campo_com 'serie', '888'
		clico_botao 'Gravar'
		consigo_ver '888' 
	end
	scenario 'deletar série' do 
		@serie = Serie.find_by(serie: '888')
		abro_pagina_as_adm 'series'
		clico_link 'Deletar'+@serie.id.to_s
		clico_ok_alerta
		nao_consigo_ver '888'
	end	
end
