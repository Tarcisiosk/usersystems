require 'rails_helper'

RSpec.describe Cfop, type: :model do
 it "campos vazios é inválido" do
  	cfop = Cfop.new
  	cfop.valid?
  	expect(cfop.errors[:codigo]).to include("não pode ficar em branco") 
  	expect(cfop.errors[:descricao]).to include("não pode ficar em branco")  	
 	
  end
  it "campos preenchidos corretamente é válido" do
  	cfop = Cfop.new(codigo: '1803', descricao:'grupo_teste')
  	expect(cfop).to be_valid 
  end 
end
