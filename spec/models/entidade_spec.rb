require 'rails_helper'

RSpec.describe Entidade, type: :model do
  it "campos vazios é inválido" do
  	entidade = Entidade.new
  	entidade.valid?
  	expect(entidade.errors[:razao_social]).to include("não pode ficar em branco")
  	expect(entidade.errors[:nome_fantasia]).to include("não pode ficar em branco")
  	expect(entidade.errors[:cnpj]).to include("não pode ficar em branco")
  end

  it "cnpj com tamanho diferente de 14 é invalido" do
  	entidade = Entidade.new(cnpj:'123456789101112')
  	entidade.valid?
  	expect(entidade.errors[:cnpj]).to include("é muito longo (máximo: 14 caracteres)") 	
  end

  it "cnpj precisa ser único" do
    entidade1 = Entidade.new(cnpj:'00000000000001')
    entidade2 = Entidade.new(cnpj:'00000000000001')
    entidade2.valid?
    expect(entidade2.errors[:cnpj]).to include("já está em uso")
  end

  it "cnpj precisa ser numerico" do
    entidade = Entidade.new(cnpj:'ceenepejota')
    entidade.valid?
    expect(entidade.errors[:cnpj]).to include("deve ter um valor numérico")
  end

  it "campos preenchidos corretamente é válido" do
  	entidade = Entidade.new(razao_social: 'Entidade_teste', nome_fantasia: "Entidade teste", cnpj: '00000000000032')
  	expect(entidade).to be_valid 
  end  	
end
