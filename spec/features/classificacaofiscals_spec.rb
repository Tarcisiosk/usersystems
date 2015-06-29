require 'rails_helper'

RSpec.feature "Classificacaofiscals", type: :feature, :js => true do
    scenario 'listar classificacoes fiscais' do					
		abro_pagina 'classificacaofiscal'		
		consigo_ver 'CLASSIFICAÇÕES FISCAIS'		
	end		
	scenario 'validar campos em branco da classificacao fiscal' do
		abro_pagina 'classificacaofiscal'			
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Codigo ncm não pode ficar em branco'
		consigo_ver	'Descricao não pode ficar em branco'
	end		
	scenario 'adicionar classificacao fiscal' do		
		abro_pagina 'classificacaofiscal'		
		clico_link 'Novo'		
		preencho_campo_com 'classificacaofiscal[codigo_ncm]', '1001'
		preencho_campo_com 'classificacaofiscal[descricao]', 'classif. fiscal Empresa MAA'		
		clico_botao 'Gravar'
		consigo_ver 'classif. fiscal Empresa MAA' 
	end
	scenario 'editar classificacao fiscal' do	
		@classificacaofiscal = Classificacaofiscal.find_by(descricao: 'classif. fiscal Empresa MAA')
		abro_pagina 'classificacaofiscal'		
		clico_link 'Editar' + @classificacaofiscal.id.to_s		
		preencho_campo_com 'classificacaofiscal[codigo_ncm]', '99'
		clico_botao 'Atualizar'
		consigo_ver '99'
	end
	scenario 'deletar classificacao fiscal' do
		@classificacaofiscal = Classificacaofiscal.find_by(descricao: 'classif. fiscal Empresa MAA')
		abro_pagina 'classificacaofiscal'
		clico_link 'Deletar'+@classificacaofiscal.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'classif. fiscal Empresa MAA'
	end	
end
