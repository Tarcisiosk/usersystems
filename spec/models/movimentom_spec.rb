require 'rails_helper'

RSpec.describe Movimentom, type: :model do
it "campos vazios é inválido" do
  	mov = Movimentom.new
  	mov.valid?
  	expect(mov.errors[:data]).to include("não pode ficar em branco")
  	expect(mov.errors[:entidade_id]).to include("não pode ficar em branco")  	

  end
  it "campos preenchidos corretamente é válido" do
  	mov = Movimentom.new(data:'12/12/2012', entidade_id: 1, adm_id: '1')
  	expect(mov).to be_valid 
  end 
end
