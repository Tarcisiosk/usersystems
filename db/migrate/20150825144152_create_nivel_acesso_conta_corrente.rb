class CreateNivelAcessoContaCorrente < ActiveRecord::Migration
  def change
     unless Acesso.exists?(modulo: "Conta Corrente", opcao: "Visualizar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Conta Corrente", :opcao => "Visualizar", :acao => "contacorrente#index", :descricao => "Permite visualização de contas correntes")
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Conta Corrente", opcao: "Criar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Conta Corrente", :opcao => "Criar", :acao => "contacorrente#new", :descricao => "Permite criação de contas correntes");
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Conta Corrente", opcao: "Editar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Conta Corrente", :opcao => "Editar", :acao => "contacorrente#edit", :descricao => "Permite edição de contas correntes");
      @acesso.save    
    end
    unless Acesso.exists?(modulo: "Conta Corrente", opcao: "Deletar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Conta Corrente", :opcao => "Deletar", :acao => "contacorrente#destroy", :descricao => "Permite exclusão de contas correntes");
  	  @acesso.save 
    end
  end
end
