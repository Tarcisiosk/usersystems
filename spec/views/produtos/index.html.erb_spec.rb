require 'rails_helper'

RSpec.describe "produtos/index", type: :view do
  before(:each) do
    assign(:produtos, [
      Produto.create!(
        :descricao => "Descricao",
        :codigo => "Codigo",
        :preco => 1.5,
        :unidade => "Unidade"
      ),
      Produto.create!(
        :descricao => "Descricao",
        :codigo => "Codigo",
        :preco => 1.5,
        :unidade => "Unidade"
      )
    ])
  end

  it "renders a list of produtos" do
    render
    assert_select "tr>td", :text => "Descricao".to_s, :count => 2
    assert_select "tr>td", :text => "Codigo".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Unidade".to_s, :count => 2
  end
end
