require 'rails_helper'

RSpec.describe Classificacaofiscal, type: :model do
  it "campos vazios é inválido" do
  	classificacaofiscal = Classificacaofiscal.new
  	classificacaofiscal.valid?
  	expect(classificacaofiscal.errors[:codigo_ncm]).to include("não pode ficar em branco")
  	expect(classificacaofiscal.errors[:descricao]).to include("não pode ficar em branco")  	
  end
  it "campos preenchidos corretamente é válido" do
  	classificacaofiscal = Classificacaofiscal.new(codigo_ncm:'1',descricao:'Animais vivos das espécies cavalar, asinina e muar')
  	expect(classificacaofiscal).to be_valid 
  end 
end
