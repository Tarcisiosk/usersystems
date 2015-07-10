require 'rails_helper'

RSpec.describe Icmsinterestadual, type: :model do
  it "campos vazios é inválido" do 
  	icmsinterestadual = Icmsinterestadual.new
  	icmsinterestadual.valid?
  	expect(icmsinterestadual.errors[:origem]).to include("não pode ficar em branco")
  	expect(icmsinterestadual.errors[:destino]).to include("não pode ficar em branco")
  	expect(icmsinterestadual.errors[:icms]).to include("não pode ficar em branco")
  end	
   it "campos preenchidos corretamente é válido" do
  	icmsinterestadual = Icmsinterestadual.new(origem:'1',destino:'1',icms:'17')
  	expect(icmsinterestadual).to be_valid 
  end 
end
