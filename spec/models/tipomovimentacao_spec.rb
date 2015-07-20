require 'rails_helper'

RSpec.describe Tipomovimentacao, type: :model do
 it "campos vazios é inválido" do
  	tipomovimentacao = Tipomovimentacao.new
  	tipomovimentacao.valid?
  	expect(tipomovimentacao.errors[:descricao]).to include("não pode ficar em branco")
  	expect(tipomovimentacao.errors[:tipo]).to include("não pode ficar em branco")
 end 
 it "campos preenchidos corretamente é válido" do
  	tipomovimentacao = Tipomovimentacao.new(descricao:'Orçamento',tipo:'Entrada')
  	expect(tipomovimentacao).to be_valid 
  end 	
end
