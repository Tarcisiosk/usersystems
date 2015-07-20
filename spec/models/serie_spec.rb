require 'rails_helper'

RSpec.describe Serie, type: :model do
  it "campos vazios é inválido" do
  	serie = Serie.new
  	serie.valid?
  	expect(serie.errors[:serie]).to include("não pode ficar em branco")
  	expect(serie.errors[:modelo]).to include("não pode ficar em branco")
  	expect(serie.errors[:ultima_nota_fiscal]).to include("não pode ficar em branco")
  	expect(serie.errors[:ambiente]).to include("não pode ficar em branco")
  end	
  it "campos númericos com valores não númericos é inválido" do 
  	serie = Serie.new(serie: '0,1', ultima_nota_fiscal: '0,1')
  	serie.valid?
  	expect(serie.errors[:serie]).to include("deve ter um valor numérico")
    expect(serie.errors[:ultima_nota_fiscal]).to include("deve ter um valor numérico")
  end	
  it "campos com valores maiores ao do máximo preestabelecido é inválido" do
  	serie = Serie.new(serie:'1000')
    serie.valid?
  	expect(serie.errors[:serie]).to include("deve ser menor ou igual a 999")
  end
  it "campos com valores maiores ao do minímo preestabelecido é inválido" do
  	serie = Serie.new(serie: '0')
    serie.valid?
  	expect(serie.errors[:serie]).to include("deve ser maior ou igual a 1")
  end
  it "campos preenchidos corretamente é válido" do
  	serie = Serie.new(serie:'1',modelo:'Nota Fiscal Eletrônica',ultima_nota_fiscal:'1',ambiente:'Producao')
  	expect(serie).to be_valid 
  end	
end
