require 'rails_helper'

RSpec.describe Produto, type: :model do
	it "campos vazios é inválido" do
  		produto = Produto.new
  		produto.valid?
  		expect(produto.errors[:descricao]).to include("não pode ficar em branco")  	
   		expect(produto.errors[:codigo]).to include("não pode ficar em branco")  	
  	end

  	it "campos preenchidos corretamente é válido" do
	  	produto = Produto.new(descricao:'produto_teste', codigo: 'asdf123', adm_id: '2')
	  	expect(produto).to be_valid 
  	end 
end
