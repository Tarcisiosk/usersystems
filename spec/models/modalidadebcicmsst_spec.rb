require 'rails_helper'

RSpec.describe Modalidadebcicmsst, type: :model do
  it "todos os dados salvos são válidos" do
  	Modalidadebcicmsst.all.each do |mod|
  	expect(mod).to be_valid	
  	end	
  end
end
