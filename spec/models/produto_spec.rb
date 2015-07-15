require 'rails_helper'

RSpec.describe Produto, type: :model do
	it "campos vazios é inválido" do
  		produto = Produto.new
  		produto.valid?
  		expect(produto.errors[:descricao]).to include("não pode ficar em branco")  	
   		expect(produto.errors[:codigo]).to include("não pode ficar em branco")  	
  	end
end
