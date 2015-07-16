require 'rails_helper'

RSpec.describe Unidade, type: :model do
 	it "campos vazios é inválido" do
	  	unidade = Unidade.new
	  	unidade.valid?
	  	expect(unidade.errors[:abreviacao]).to include("não pode ficar em branco") 
	  	expect(unidade.errors[:descricao]).to include("não pode ficar em branco")  	
 	
 	 end
  	it "campos preenchidos corretamente é válido" do
	  	unidade = Unidade.new(abreviacao: 'TN', descricao:'toneladas')
	  	expect(unidade).to be_valid 
	end
end