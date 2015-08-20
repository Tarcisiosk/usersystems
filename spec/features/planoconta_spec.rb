require 'rails_helper'

RSpec.feature "Planoconta", type: :feature, :js => true do
	scenario 'listar planos de contas' do 
		abro_pagina 'planocontas'
		consigo_ver 'PLANOS DE CONTAS'
	end	

	scenario 'validar campos do plano de conta' do 
		abro_pagina 'planocontas'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver 'Descricao não pode ficar em branco'
	end	

	scenario 'adicionar plano de conta pai 1' do
		abro_pagina 'planocontas'
		clico_link 'Novo'
		escolho_radio 'Receita'
		clico_botao 'Gravar' 
		consigo_ver '1'
	end	

	scenario 'adicionar plano de conta pai 2' do 
		abro_pagina 'planocontas'
		clico_link 'Novo'
		escolho_radio 'Despesa'
		clico_botao 'Gravar' 
		consigo_ver '2'
	end	

	scenario 'adicionar plano de conta filho 1 do plano de conta pai 1' do
		@planoconta = Planoconta.find_by(codigo: '1') 
		abro_pagina 'planocontas'
		clico_link 'Incluir' + @planoconta.id.to_s
		preencho_campo_com 'descricao', 'FILHO I DO PAI I'
		clico_botao 'Gravar'
		consigo_ver '1.01'
	end	

	scenario 'adicionar plano de conta filho 2 do plano de conta pai 1' do
		@planoconta = Planoconta.find_by(codigo: '1') 
		abro_pagina 'planocontas'
		clico_link 'Incluir' + @planoconta.id.to_s
		preencho_campo_com 'descricao', 'FILHO II DO PAI I'
		clico_botao 'Gravar'
		consigo_ver '1.02'
	end

	scenario 'editar plano de conta' do 
		@planoconta = Planoconta.find_by(codigo: '1')
		abro_pagina 'planocontas'
		clico_link 'Editar' + @planoconta.id.to_s
		escolho_radio 'Forma de Pagamento'
		clico_botao 'Gravar'
		consigo_ver 'Forma de Pagamento'
	end	 

	scenario 'deletar plano de conta 1' do 
		@planoconta = Planoconta.find_by(codigo: '1')
		abro_pagina 'planocontas'
		clico_link 'Deletar' + @planoconta.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'Forma de Pagamento'				
	end
	scenario 'deletar plano de conta 2' do 
		@planoconta = Planoconta.find_by(codigo: '2')
		abro_pagina 'planocontas'
		clico_link 'Deletar' + @planoconta.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'Despesa'				
	end
end
