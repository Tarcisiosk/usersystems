require 'rails_helper'

RSpec.describe Nivelacesso, type: :model do
  it "campos vazios é inválido" do
  	nivelacesso = Nivelacesso.new
  	nivelacesso.valid?
  	expect(nivelacesso.errors[:descricao]).to include("não pode ficar em branco")  	
  end
  it "campos preenchidos corretamente é válido" do
  	nivelacesso = Nivelacesso.new(descricao:'nivelacesso_teste', adm_id: '1')
  	expect(nivelacesso).to be_valid 
  end 
end
