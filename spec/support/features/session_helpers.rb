module Features
  module SessionHelpers
    def faco_login_com(email, password)
      visit 'http://localhost:3000'
      if find("#user_email")
        preencho_campo_com 'Email', email
        preencho_campo_com 'Senha', password
        clico_botao 'Fazer Login'
      end
    end

    def abro_pagina(path)
    	faco_login_com 'master@hotmail.com','senha123'
    	visit 'http://localhost:3000/' + path
    end  
    
    def abro_pagina_as_adm(path)
      faco_login_com 'usuarioteste@hotmail.com','12345678'
      visit 'http://localhost:3000/' + path
    end  
    
    def preencho_campo_com(name,value)
    	fill_in name, with: value
    end

    def clico_botao(value)
    	click_button value
    end

    def clico_link(value)
    	click_link value
    end	

    def consigo_ver(value)
    	expect(page).to have_content(value)
    end

    def nao_consigo_ver(value)
    	expect(page).to_not have_content(value)
    end

    def clico_ok_alerta
    	page.evaluate_script('window.confirm = function() { return true; }')    			
   	end

   	def clico_cancelar_alerta
   		page.evaluate_script('window.confirm = function() { return true; }')		
   	end	

    def escolho_empresa (empresa)
      find('#empresa_menu_dropdown').hover
      page.execute_script("$('##{empresa}').click()")      
    end  

  end  
end    