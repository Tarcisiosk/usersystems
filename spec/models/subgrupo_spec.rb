require 'rails_helper'

RSpec.describe Subgrupo, type: :model do
  it "campos vazios é inválido" do
  	subgrupo = Subgrupo.new
  	subgrupo.valid?
  	expect(subgrupo.errors[:descricao]).to include("não pode ficar em branco")  	
  end
  it "campos preenchidos corretamente é válido" do
  	subgrupo = Subgrupo.new(descricao:'subgrupo_teste', grupo_id: '1', adm_id: '1')
  	expect(subgrupo).to be_valid 
  end 
end
