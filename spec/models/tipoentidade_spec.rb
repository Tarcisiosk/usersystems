require 'rails_helper'

RSpec.describe Tipoentidade, type: :model do
 it "campos vazios é inválido" do
  	tipo = Tipoentidade.new
  	tipo.valid?
  	expect(tipo.errors[:descricao]).to include("não pode ficar em branco")  	
  end
  it "campos preenchidos corretamente é válido" do
  	tipo = Tipoentidade.new(descricao:'tipo_teste')
  	expect(tipo).to be_valid 
  end 
end
