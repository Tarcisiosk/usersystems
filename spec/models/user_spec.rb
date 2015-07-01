require 'rails_helper'

RSpec.describe User, type: :model do
  it "campos vazios é inválido" do
  	user = User.new
  	user.valid?
  	expect(user.errors[:fullname]).to include("não pode ficar em branco")
  	expect(user.errors[:email]).to include("não pode ficar em branco")
  end

  it "email não é email" do
  	user = User.new(fullname:"notemail", email:'naoeumemail')
  	user.valid?
  	expect(user.errors[:email]).to include("não é um email") 	
  end

  it "email precisa ser único" do
    u1 = User.new(fullname: "nome_teste", email: "master@hotmail.com")
    u2 = User.new(fullname: "nome_teste", email: "master@hotmail.com")
    u2.valid?
    expect(u2.errors[:email]).to include("já está em uso")
  end


  it "campos preenchidos corretamente é válido" do
  	user = User.new(fullname: "nome_teste", email: "email@email.com", password: "12345678", password_confirmation: "12345678")
  	expect(user).to be_valid 
  end  	
end
