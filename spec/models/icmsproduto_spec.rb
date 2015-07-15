require 'rails_helper'

RSpec.describe Icmsproduto, type: :model do
it "campos vazios é inválido" do 
  	icmsproduto = Icmsproduto.new
  	icmsproduto.valid?
  	expect(icmsproduto.errors[:reducaobasecalculo]).to include("não pode ficar em branco")
  	expect(icmsproduto.errors[:diferimento]).to include("não pode ficar em branco")
  	expect(icmsproduto.errors[:aliquota]).to include("não pode ficar em branco")
  end	

  it "campos númericos com valores não numéricos é inválido" do
  	icmsproduto = Icmsproduto.new(reducaobasecalculo:'0,1',diferimento:'0,1',aliquota:'0,1')
    icmsproduto.valid?
  	expect(icmsproduto.errors[:reducaobasecalculo]).to include("deve ter um valor numérico")
  	expect(icmsproduto.errors[:diferimento]).to include("deve ter um valor numérico")
  	expect(icmsproduto.errors[:aliquota]).to include("deve ter um valor numérico")
  end
  it "campos com valores maiores ao do máximo preestabelecido é inválido" do
  	icmsproduto = Icmsproduto.new(reducaobasecalculo:'101',diferimento:'101',aliquota:'51')
    icmsproduto.valid?
  	expect(icmsproduto.errors[:reducaobasecalculo]).to include("deve ser menor ou igual a 100")
  	expect(icmsproduto.errors[:diferimento]).to include("deve ser menor ou igual a 100")
  	expect(icmsproduto.errors[:aliquota]).to include("deve ser menor ou igual a 50")
  end

  it "campos com valores menores ao do mínimo preestabelecido é inválido" do
  	icmsproduto = Icmsproduto.new(reducaobasecalculo:'-1',diferimento:'-1',aliquota:'-1')
    icmsproduto.valid?
  	expect(icmsproduto.errors[:reducaobasecalculo]).to include("deve ser maior ou igual a 0")
  	expect(icmsproduto.errors[:diferimento]).to include("deve ser maior ou igual a 0")
  	expect(icmsproduto.errors[:aliquota]).to include("deve ser maior ou igual a 0")
  end	
end
