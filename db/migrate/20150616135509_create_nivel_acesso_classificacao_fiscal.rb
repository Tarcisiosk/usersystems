class CreateNivelAcessoClassificacaoFiscal < ActiveRecord::Migration
  def change  
  	unless Acesso.exists?(modulo: "Classificação Fiscal", opcao: "Visualizar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Classificação Fiscal", :opcao => "Visualizar", :acao => "classificacaofiscal#index", :descricao => "Permite visualização de classificações fiscais")
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Classificação Fiscal", opcao: "Criar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Classificação Fiscal", :opcao => "Criar", :acao => "classificacaofiscal#new", :descricao => "Permite criação de classificações fiscais");
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Classificação Fiscal", opcao: "Editar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Classificação Fiscal", :opcao => "Editar", :acao => "classificacaofiscal#edit", :descricao => "Permite edição de classificações fiscais");
      @acesso.save    
    end
    unless Acesso.exists?(modulo: "Classificação Fiscal", opcao: "Deletar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Classificação Fiscal", :opcao => "Deletar", :acao => "classificacaofiscal#destroy", :descricao => "Permite exclusão de classificações fiscais");
  	  @acesso.save 
    end
  end
end
