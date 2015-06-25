require 'spec_helper'
require 'rails_helper'
feature 'Master Sign Up' do
	scenario 'with valid email and password' do
		sign_up_with 'master@hotmail.com', 'senha123'
		expect(page).to have_content('Página Inicial')
	end

	scenario 'without valid email and password' do
		sign_up_with 'master@hotmail.com', '123'
		expect(page).to have_content('email ou senha inválido')
	end		 	
end
