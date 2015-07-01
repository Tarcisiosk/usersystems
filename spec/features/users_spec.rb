require 'rails_helper'

RSpec.feature "Users", type: :feature, :js => true do
 	scenario 'listar usuarios' do					
		abro_pagina 'users'
		consigo_ver 'UsuarioTeste'		
	end

	scenario 'validar campos em branco do usuario' do
		abro_pagina 'users'
		clico_link 'Novo'
		clico_botao 'Gravar'
		consigo_ver	'Email não pode ficar em branco'
		consigo_ver	'Email não é um email'
		consigo_ver	'Senha não pode ficar em branco'
		consigo_ver	'Nome Completo não pode ficar em branco'
		consigo_ver	'Confirmação da senha não pode ficar em branco'
	end
	
	scenario 'adicionar usuario' do		
		abro_pagina 'users'
		clico_link 'Novo'
		preencho_campo_com 'user[fullname]', 'UsuarioTeste2'
		preencho_campo_com 'user[email]', 'usuarioteste2@hotmail.Completo'
		preencho_campo_com 'user[password]', '12345678'
		preencho_campo_com 'user[password_confirmation]', '12345678'
		clico_botao 'Gravar'
		consigo_ver 'UsuarioTeste2' 
	end

	scenario 'editar usuario' do	
		@user = User.find_by(fullname: 'UsuarioTeste2')
		abro_pagina 'users'	
		clico_link 'Editar' + @user.id.to_s		
		preencho_campo_com 'user[fullname]', 'UsuarioTeste 2'
		clico_botao 'Atualizar'
		consigo_ver 'UsuarioTeste 2'
	end

	scenario 'deletar usuario' do
		@user = User.find_by(fullname: 'UsuarioTeste 2')
		abro_pagina 'users'
		clico_link 'Deletar'+ @user.id.to_s
		clico_ok_alerta
		nao_consigo_ver 'UsuarioTeste 2'
	end	
end
