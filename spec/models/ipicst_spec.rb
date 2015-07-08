require 'rails_helper'

RSpec.describe Ipicst, type: :model do
  it "todos os dados salvos são válidos" do
  	Ipicst.all.each do |ipi|
  	expect(ipi).to be_valid	
  	end	
  end
end
