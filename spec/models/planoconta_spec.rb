require 'rails_helper'

RSpec.describe Planoconta, type: :model do
  it "campos vazios é inválido" do 
  	planoconta = Planoconta.new
  	planoconta.valid?
  	expect(planoconta.errors[:descricao]).to include("não pode ficar em branco")
  end
  
  it "campos preenchidos corretamento é válido" do 
  	planoconta = Planoconta.new(descricao: 'teste')
  	expect(planoconta).to be_valid
  end 

end
