require 'rails_helper'

RSpec.describe Grupo, type: :model do
 it "campos vazios é inválido" do
  	grupo = Grupo.new
  	grupo.valid?
  	expect(grupo.errors[:descricao]).to include("não pode ficar em branco")  	
  end
  it "campos preenchidos corretamente é válido" do
  	grupo = Grupo.new(descricao:'grupo_teste')
  	expect(grupo).to be_valid 
  end 
end
