require 'rails_helper'

RSpec.describe Icmsclassificacaofiscal, type: :model do
  it "campos vazios é inválido" do 
  	icmsclassificacaofiscal = Icmsclassificacaofiscal.new
  	icmsclassificacaofiscal.valid?
  	expect(icmsclassificacaofiscal.errors[:reducaobasecalculo]).to include("não pode ficar em branco")
  	expect(icmsclassificacaofiscal.errors[:diferimento]).to include("não pode ficar em branco")
  	expect(icmsclassificacaofiscal.errors[:aliquota]).to include("não pode ficar em branco")
  end	

  it "campos númericos com valores não numéricos é inválido" do
  	icmsclassificacaofiscal = Icmsclassificacaofiscal.new(reducaobasecalculo:'0,1',diferimento:'0,1',aliquota:'0,1')
    icmsclassificacaofiscal.valid?
  	expect(icmsclassificacaofiscal.errors[:reducaobasecalculo]).to include("deve ter um valor numérico")
  	expect(icmsclassificacaofiscal.errors[:diferimento]).to include("deve ter um valor numérico")
  	expect(icmsclassificacaofiscal.errors[:aliquota]).to include("deve ter um valor numérico")
  end
  it "campos com valores maiores ao do máximo preestabelecido é inválido" do
  	icmsclassificacaofiscal = Icmsclassificacaofiscal.new(reducaobasecalculo:'101',diferimento:'101',aliquota:'51')
    icmsclassificacaofiscal.valid?
  	expect(icmsclassificacaofiscal.errors[:reducaobasecalculo]).to include("deve ser menor ou igual a 100")
  	expect(icmsclassificacaofiscal.errors[:diferimento]).to include("deve ser menor ou igual a 100")
  	expect(icmsclassificacaofiscal.errors[:aliquota]).to include("deve ser menor ou igual a 50")
  end

  it "campos com valores menores ao do mínimo preestabelecido é inválido" do
  	icmsclassificacaofiscal = Icmsclassificacaofiscal.new(reducaobasecalculo:'-1',diferimento:'-1',aliquota:'-1')
    icmsclassificacaofiscal.valid?
  	expect(icmsclassificacaofiscal.errors[:reducaobasecalculo]).to include("deve ser maior ou igual a 0")
  	expect(icmsclassificacaofiscal.errors[:diferimento]).to include("deve ser maior ou igual a 0")
  	expect(icmsclassificacaofiscal.errors[:aliquota]).to include("deve ser maior ou igual a 0")
  end	
end
