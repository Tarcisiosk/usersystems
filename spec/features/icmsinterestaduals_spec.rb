require 'rails_helper'

RSpec.feature "Icmsinterestaduals", type: :feature, :js => true do
  scenario 'listar icms interestadual' do					
		abro_pagina 'icmsinterestadual'		
		consigo_ver 'ICMS INTERESTADUAL'		
  end
  scenario 'editar icms interestadual' do 
  	abro_pagina 'icmsinterestadual'
  	preencho_campo_com 'icmsinterestadual01', '12'
  	clico_botao 'Gravar'
  	consigo_ver 'Sucesso!'
  end	
end
