require 'rails_helper'

RSpec.feature "Contacorrentes", type: :feature, :js => true do

	scenario 'adicionar empresa/contato conta corrente' do 
		@tipoentidade = Tipoentidade.find_by(descricao: 'Tipo Mastercim')
		if @tipoentidade.blank?
			abro_pagina 'tipoentidades'
			clico_link 'Novo'
			preencho_campo_com 'tipoentidade[descricao]', 'Tipo Mastercim'
			clico_botao 'Gravar'
			consigo_ver 'Tipo Mastercim'
		end
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		if @entidade.blank?
			abro_pagina 'entidades'
			clico_link 'Novo'
			marco_checkbox 'tipo2'
			preencho_campo_com 'razao_social', 'Mastercim'
			preencho_campo_com 'nome_fantasia', 'Infocase'
			preencho_campo_com 'cnpj', '70413361000145'
			clico_botao 'Salvar'
			consigo_ver 'Infocase'
		end
	end

	scenario 'visualizar opcao de acesso a conta corrente pela empresa/contato' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		abro_pagina 'entidades'
		clico_link 'Settings'+@entidade.id.to_s
		consigo_ver 'Conta Corrente'
	end

	scenario 'listar contas correntes' do					
		abro_pagina 'contacorrentes'		
		consigo_ver 'CONTAS CORRENTES'		
	end	

	scenario 'validar campos da conta corrente' do
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Valor não pode ficar em branco
					 Valor deve ter um valor numérico
					 Documento não pode ficar em branco
					 Descricao não pode ficar em branco'
	end

	scenario 'adicionar conta corrente 1' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Novo'
		preencho_campo_com 'descricao', 'credito 100'
		preencho_campo_com 'data', Time.now.strftime("%d/%m/%Y")
		preencho_campo_com 'documento', 'doc'
		preencho_campo_com 'valor', '100'
		clico_botao 'Gravar'
		consigo_ver 'credito 100'
	end	

	scenario 'adicionar conta corrente 2' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Novo'
		preencho_campo_com 'descricao', 'debito 150'
		preencho_campo_com 'data', Time.now.strftime("%d/%m/%Y")
		preencho_campo_com 'documento', 'doc'
		preencho_campo_com 'valor', '-150'
		clico_botao 'Gravar'
		consigo_ver 'debito 150'
	end	

	scenario 'verificar calculo saldo' do
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		consigo_ver '-50'
	end

	scenario 'editar conta corrente 1' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		@contacorrente = Contacorrente.find_by(descricao: 'credito 100')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Editar' + @contacorrente.id.to_s
		preencho_campo_com 'descricao', 'credito 200'
		preencho_campo_com 'valor', '200'
		clico_botao 'Gravar'
		consigo_ver 'credito 200'
	end

	scenario 'deletar conta corrente 1' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		@contacorrente = Contacorrente.find_by(descricao: 'credito 200')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Deletar' + @contacorrente.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'credito 200'
	end

	scenario 'deletar conta corrente 2' do 
		@entidade = Entidade.find_by(razao_social: 'Mastercim')
		@contacorrente = Contacorrente.find_by(descricao: 'debito 150')
		abro_pagina 'contacorrentes?entidade='+@entidade.id.to_s
		clico_link 'Deletar' + @contacorrente.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'debito 150'
	end
end	