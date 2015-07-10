require 'rails_helper'

RSpec.feature "Classificacaofiscals", type: :feature, :js => true do
	
    scenario 'listar classificacoes fiscais' do					
		abro_pagina 'classificacaofiscal'		
		consigo_ver 'CLASSIFICAÇÕES FISCAIS'		
	end		
	scenario 'validar campos da classificacao fiscal' do
		abro_pagina 'classificacaofiscal'			
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Codigo ncm não pode ficar em branco
					Descricao não pode ficar em branco
					Pis cst não pode ficar em branco
					Cofins cst não pode ficar em branco
					Ipi cst não pode ficar em branco'
	end	

	scenario 'validar campos de um icms da classificacao fiscal' do 
		abro_pagina 'classificacaofiscal'			
		clico_link 'Novo'
		clico_link 'tabicmsclassificacaofiscal'
		clico_primeiro_link 'editarIcms'
		preencho_campo_com 'reducaobasecalculo', ''
		preencho_campo_com 'aliquota',''
		clico_botao 'Salvar'
		consigo_ver 'Reducaobasecalculo não pode ficar em branco
					Reducaobasecalculo deve ter um valor numérico
					Aliquota não pode ficar em branco
					Aliquota deve ter um valor numérico'
	end	
		
	scenario 'adicionar classificacao fiscal' do		
		abro_pagina 'classificacaofiscal'		
		clico_link 'Novo'		
		preencho_campo_mascarado_com 'codigo_ncm', '02011100'
		preencho_campo_mascarado_com 'codigo_ex', '02'
		preencho_campo_com 'descricao', 'classif. fiscal Empresa MAA'
		clico_link 'tabimpostos'
		seleciono_opcao_do '1 - Operação Tributável com Alíquota Básica.', 'pis_cst_id'	
		preencho_campo_com 'pis_aliquota', '0.1'
		seleciono_opcao_do '2 - Operação Tributável com Alíquota Diferenciada.', 'cofins_cst_id'
		preencho_campo_com 'cofins_aliquota', '0.2'
		preencho_campo_com 'ii_aliquota', '0.3'
		seleciono_opcao_do '4 - Entrada/Saída Imune', 'ipi_cst_id'
		preencho_campo_com 'ipi_aliquota', '0.4'
		clico_link 'tabicmsclassificacaofiscal'
		clico_primeiro_link 'editarIcms'
		preencho_campo_com 'reducaobasecalculo','0.11'
		preencho_campo_com 'aliquota','0.13'
		marco_checkbox 'icmsst'
		seleciono_opcao_do '2 - Lista Positiva (valor)','modalidadebcicmsst_id'
		clico_botao 'Salvar'			
		clico_botao 'Gravar'
		consigo_ver 'classif. fiscal Empresa MAA' 
	end
	
	scenario 'editar classificacao fiscal' do	
		@classificacaofiscal = Classificacaofiscal.find_by(descricao: 'classif. fiscal Empresa MAA')
		abro_pagina 'classificacaofiscal'		
		clico_link 'Editar' + @classificacaofiscal.id.to_s		
		preencho_campo_mascarado_com 'codigo_ncm', '11111111'
		clico_botao 'Gravar'
		consigo_ver '1111.11.11'
	end
	scenario 'deletar classificacao fiscal' do
		@classificacaofiscal = Classificacaofiscal.find_by(descricao: 'classif. fiscal Empresa MAA')
		abro_pagina 'classificacaofiscal'
		clico_link 'Deletar'+@classificacaofiscal.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'classif. fiscal Empresa MAA'
	end			
end
