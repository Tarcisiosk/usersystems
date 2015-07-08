require 'rails_helper'

RSpec.describe Piscofinscst, type: :model do
  it "todos os dados salvos são válidos" do
  	Piscofinscst.all.each do |pcc|
  	expect(pcc).to be_valid	
  	end	
  end
end
