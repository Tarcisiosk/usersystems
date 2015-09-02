require 'rails_helper'

RSpec.describe Contacorrente, type: :model do
  it "campos vazios é inválido" do
  	contacorrente = Contacorrente.new
  	contacorrente.valid?
  	expect(contacorrente.errors[:data]).to include("não pode ficar em branco")
  	expect(contacorrente.errors[:valor]).to include("não pode ficar em branco")
  	expect(contacorrente.errors[:documento]).to include("não pode ficar em branco")
  	expect(contacorrente.errors[:descricao]).to include("não pode ficar em branco")
  end

  it "campos númericos com valores não númericos é inválido" do 
  	contacorrente = Contacorrente.new(valor:'0,1')
  	contacorrente.valid?
  	expect(contacorrente.errors[:valor]).to include("deve ter um valor numérico")
  end	

   it "campos preenchidos corretamente é válido" do
   	contacorrente = Contacorrente.new(data:'2015-09-01',valor:'100',documento:'A',descricao:'A')
   	expect(contacorrente).to be_valid 	
   end	
end
