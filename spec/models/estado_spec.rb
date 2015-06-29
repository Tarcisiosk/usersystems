require 'rails_helper'

RSpec.describe Estado, type: :model do
  it "campos vazios é inválido" do
  	estado = Estado.new
  	estado.valid?
  	expect(estado.errors[:codigo_ibge]).to include("não pode ficar em branco")
  	expect(estado.errors[:uf]).to include("não pode ficar em branco")
  	expect(estado.errors[:descricao]).to include("não pode ficar em branco")
  	expect(estado.errors[:icms_interno]).to include("não pode ficar em branco")
  	expect(estado.errors[:diferimento]).to include("não pode ficar em branco")
  end
  it "uf com tamanho maior que dois é inválido" do
  	estado = Estado.new(uf:'XXXX')
  	estado.valid?
  	expect(estado.errors[:uf]).to include("é muito longo (máximo: 2 caracteres)") 	
  end
  it "descricao com tamanho maior que 50 é inválido" do
  	estado = Estado.new(descricao:'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
  	estado.valid?
  	expect(estado.errors[:descricao]).to include("é muito longo (máximo: 50 caracteres)") 	
  end
  it "campos preenchidos corretamente é válido" do
  	estado = Estado.new(codigo_ibge:'33',uf:'RJ',descricao:'Rio de Janeiro',icms_interno:'15',diferimento:'12')
  	expect(estado).to be_valid 
  end  	
end