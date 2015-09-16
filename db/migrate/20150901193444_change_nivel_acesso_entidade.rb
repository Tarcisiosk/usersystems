class ChangeNivelAcessoEntidade < ActiveRecord::Migration
  def change
  	unless Acesso.exists?(modulo: "Empresas/Contatos", opcao: "Configurar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Empresas/Contatos", :opcao => "Configurar", :acao => "entidade#configurar", :descricao => "Permite acessar as configurações da entidade")
      @acesso.save
    end
  end
end
