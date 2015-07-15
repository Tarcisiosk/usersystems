require 'rails_helper'

RSpec.feature "Produtos", type: :feature, :js => true do
	scenario 'listar produto' do					
		abro_pagina 'produtos'
	end

	scenario 'validar campos em branco do produto' do
		abro_pagina 'produtos'
		clico_link 'Novo'
		clico_botao 'Salvar'
		consigo_ver	'Descricao não pode ficar em branco'
		consigo_ver	'Codigo não pode ficar em branco'

	end
	
	scenario 'adicionar produto' do		
		abro_pagina 'produtos'
		clico_link 'Novo'
		preencho_campo_com 'descricao_desc', 'produtoTeste2'
		preencho_campo_com 'codigo', '696'

		clico_botao 'Salvar'
		consigo_ver 'produtoTeste2' 
	end

	scenario 'editar produto' do	
		@produto = Produto.find_by(descricao: 'produtoTeste2')
		abro_pagina 'produtos'	
		clico_link 'Editar' + @produto.id.to_s		
		preencho_campo_com 'descricao_desc', 'produtoTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'produtoTeste 2'
	end
	
	scenario 'deletar produto ' do
		@produto = Produto.find_by(descricao: 'produtoTeste 2')
		abro_pagina 'produtos'
		clico_link 'Deletar'+ @produto.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'produtoTeste 2'
	end	

end
