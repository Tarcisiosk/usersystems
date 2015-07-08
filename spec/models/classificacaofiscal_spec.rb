require 'rails_helper'

RSpec.describe Classificacaofiscal, type: :model do
  it "campos vazios é inválido" do
  	classificacaofiscal = Classificacaofiscal.new
  	classificacaofiscal.valid?
  	expect(classificacaofiscal.errors[:codigo_ncm]).to include("não pode ficar em branco")
  	expect(classificacaofiscal.errors[:descricao]).to include("não pode ficar em branco")  
    expect(classificacaofiscal.errors[:pis_cst_id]).to include("não pode ficar em branco")  
    expect(classificacaofiscal.errors[:pis_aliquota]).to include("não pode ficar em branco")
    expect(classificacaofiscal.errors[:cofins_cst_id]).to include("não pode ficar em branco")  
    expect(classificacaofiscal.errors[:cofins_aliquota]).to include("não pode ficar em branco")  
    expect(classificacaofiscal.errors[:ii_aliquota]).to include("não pode ficar em branco") 
    expect(classificacaofiscal.errors[:ipi_cst_id]).to include("não pode ficar em branco")  
    expect(classificacaofiscal.errors[:ipi_aliquota]).to include("não pode ficar em branco")   	
  end

  it "campos númericos com valores não númericos é inválido" do 
    classificacaofiscal = Classificacaofiscal.new(pis_aliquota:'0,1',cofins_aliquota:'0,1',ii_aliquota:'0,1',ipi_aliquota:'0,1')
    classificacaofiscal.valid?
    expect(classificacaofiscal.errors[:pis_aliquota]).to include("deve ter um valor numérico")
    expect(classificacaofiscal.errors[:cofins_aliquota]).to include("deve ter um valor numérico")
    expect(classificacaofiscal.errors[:ii_aliquota]).to include("deve ter um valor numérico")
    expect(classificacaofiscal.errors[:ipi_aliquota]).to include("deve ter um valor numérico")
  end  

  it "campos preenchidos corretamente é válido" do
  	classificacaofiscal = Classificacaofiscal.new(codigo_ncm:'1',descricao:'Animais vivos das espécies cavalar, asinina e muar',pis_cst_id:'1',
      pis_aliquota:'0.1',cofins_cst_id:'1',cofins_aliquota:'0.1',ii_aliquota:'0.1',ipi_cst_id:'0.1',ipi_aliquota:'0.1')
  	expect(classificacaofiscal).to be_valid 
  end 
end
