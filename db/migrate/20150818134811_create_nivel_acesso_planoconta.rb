class CreateNivelAcessoPlanoconta < ActiveRecord::Migration
  def change
    unless Acesso.exists?(modulo: "Plano de Conta", opcao: "Visualizar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Plano de Conta", :opcao => "Visualizar", :acao => "planoconta#index", :descricao => "Permite visualização dos planos de contas")
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Plano de Conta", opcao: "Plano de Conta")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Plano de Conta", :opcao => "Criar", :acao => "planoconta#new", :descricao => "Permite criação de planos de contas");
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Plano de Conta", opcao: "Editar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Plano de Conta", :opcao => "Editar", :acao => "planoconta#edit", :descricao => "Permite edição de planos de contas");
      @acesso.save    
    end
    unless Acesso.exists?(modulo: "Plano de Conta", opcao: "Deletar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Plano de Conta", :opcao => "Deletar", :acao => "planoconta#destroy", :descricao => "Permite exclusão de planos de contas");
  	  @acesso.save 
    end
  end
end
