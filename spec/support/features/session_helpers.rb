module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit 'http://localhost:3000'
      fill_in 'Email', with: email
      fill_in 'Senha', with: password
      click_button 'Fazer Login'
    end
  end
end    