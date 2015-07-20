class CreateNivelAcessoSerie < ActiveRecord::Migration
  def change
    unless Acesso.exists?(modulo: "Série", opcao: "Visualizar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Série", :opcao => "Visualizar", :acao => "serie#index", :descricao => "Permite visualização de séries")
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Série", opcao: "Criar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Série", :opcao => "Criar", :acao => "serie#new", :descricao => "Permite criação de séries");
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Série", opcao: "Editar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Série", :opcao => "Editar", :acao => "serie#edit", :descricao => "Permite edição de séries");
      @acesso.save    
    end
    unless Acesso.exists?(modulo: "Série", opcao: "Deletar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Série", :opcao => "Deletar", :acao => "serie#destroy", :descricao => "Permite exclusão de séries");
  	  @acesso.save 
    end
  end
end
