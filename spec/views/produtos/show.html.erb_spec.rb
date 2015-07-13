require 'rails_helper'

RSpec.describe "produtos/show", type: :view do
  before(:each) do
    @produto = assign(:produto, Produto.create!(
      :descricao => "Descricao",
      :codigo => "Codigo",
      :preco => 1.5,
      :unidade => "Unidade"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Descricao/)
    expect(rendered).to match(/Codigo/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Unidade/)
  end
end
