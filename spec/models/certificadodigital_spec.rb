require 'rails_helper'

RSpec.describe Certificadodigital, type: :model do
  it "todos os dados salvos são válidos" do
  	Certificadodigital.all.each do |cd|
  	expect(cd).to be_valid	
  	end	
  end
end
