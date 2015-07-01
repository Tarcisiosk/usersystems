require 'rails_helper'

RSpec.describe Empresa, type: :model do
  it "campos vazios é inválido" do
  	empresa = Empresa.new
  	empresa.valid?
  	expect(empresa.errors[:razao_social]).to include("não pode ficar em branco")
  	expect(empresa.errors[:nome_fantasia]).to include("não pode ficar em branco")
  	expect(empresa.errors[:cnpj]).to include("não pode ficar em branco")
  end

  it "cnpj com tamanho diferente de 14 é invalido" do
  	empresa = Empresa.new(cnpj:'12345678910111210100')
  	empresa.valid?
  	expect(empresa.errors[:cnpj]).to include("é muito longo (máximo: 14 caracteres)") 	
  end

  it "cnpj precisa ser único" do
    empresa1 = Empresa.new(cnpj:'00000000000001')
    empresa2 = Empresa.new(cnpj:'00000000000001')
    empresa2.valid?
    expect(empresa2.errors[:cnpj]).to include("já está em uso")
  end

  it "cnpj precisa ser numerico" do
    empresa = Empresa.new(cnpj:'ceenepejota')
    empresa.valid?
    expect(empresa.errors[:cnpj]).to include("deve ter um valor numérico")
  end

  it "campos preenchidos corretamente é válido" do
  	empresa = Empresa.new(razao_social: 'Empresa_teste', nome_fantasia: "Empresa teste", cnpj: '00000000000032')
  	expect(empresa).to be_valid 
  end  	
end
