require "rails_helper"

RSpec.describe ProdutosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/produtos").to route_to("produtos#index")
    end

    it "routes to #new" do
      expect(:get => "/produtos/new").to route_to("produtos#new")
    end

    it "routes to #show" do
      expect(:get => "/produtos/1").to route_to("produtos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/produtos/1/edit").to route_to("produtos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/produtos").to route_to("produtos#create")
    end

    it "routes to #update" do
      expect(:put => "/produtos/1").to route_to("produtos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/produtos/1").to route_to("produtos#destroy", :id => "1")
    end

  end
end
