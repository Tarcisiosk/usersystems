require 'rails_helper'

RSpec.feature "Empresas", type: :feature, :js => true do
   	scenario 'listar empresas' do					
		abro_pagina_as_adm 'empresas'
		consigo_ver 'EmpresaTeste'		
	end

	scenario 'validar campos em branco da empresa' do
		abro_pagina_as_adm 'empresas'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver	'Razão social não pode ficar em branco'
		consigo_ver	'Nome Fantasia não pode ficar em branco'
		consigo_ver	'Cnpj não pode ficar em branco'
	end
	
	scenario 'adicionar empresa' do		
		abro_pagina_as_adm 'empresas'
		clico_link 'Novo'
		preencho_campo_com 'empresa[razao_social]', 'EmpresaTeste2'
		preencho_campo_com 'empresa[nome_fantasia]', 'EmpresaTeste2'
		preencho_campo_com 'empresa[cnpj]', '73573735737357'
		clico_botao 'Gravar'
		consigo_ver 'EmpresaTeste2' 
	end

	scenario 'editar empresa' do	
		@empresa = Empresa.find_by(razao_social: 'EmpresaTeste 2')
		abro_pagina_as_adm 'empresas'	
		clico_link 'Editar' + @empresa.id.to_s		
		preencho_campo_com 'empresa[razao_social]', 'EmpresaTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'EmpresaTeste 2'
	end

#	scenario 'deletar empresa' do
#		@empresa = Empresa.find_by(razao_social: 'EmpresaTeste 2')
#		abro_pagina_as_adm 'empresas'
#		clico_link 'Deletar'+ @empresa.id.to_s
#		clico_ok_alerta
#		nao_consigo_ver 'EmpresaTeste 2'
#	end	
end
