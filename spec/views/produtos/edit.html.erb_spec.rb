require 'rails_helper'

RSpec.describe "produtos/edit", type: :view do
  before(:each) do
    @produto = assign(:produto, Produto.create!(
      :descricao => "MyString",
      :codigo => "MyString",
      :preco => 1.5,
      :unidade => "MyString"
    ))
  end

  it "renders the edit produto form" do
    render

    assert_select "form[action=?][method=?]", produto_path(@produto), "post" do

      assert_select "input#produto_descricao[name=?]", "produto[descricao]"

      assert_select "input#produto_codigo[name=?]", "produto[codigo]"

      assert_select "input#produto_preco[name=?]", "produto[preco]"

      assert_select "input#produto_unidade[name=?]", "produto[unidade]"
    end
  end
end
