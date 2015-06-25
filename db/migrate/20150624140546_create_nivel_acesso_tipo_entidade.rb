class CreateNivelAcessoTipoEntidade < ActiveRecord::Migration
  def change
    unless Acesso.exists?(modulo: "Tipo Entidade", opcao: "Visualizar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Tipo Entidade", :opcao => "Visualizar", :acao => "tipoentidade#index", :descricao => "Permite visualização de tipo de entidades")
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Tipo Entidade", opcao: "Criar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Tipo Entidade", :opcao => "Criar", :acao => "tipoentidade#new", :descricao => "Permite criação de tipo de entidades");
      @acesso.save
    end
    unless Acesso.exists?(modulo: "Tipo Entidade", opcao: "Editar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Tipo Entidade", :opcao => "Editar", :acao => "tipoentidade#edit", :descricao => "Permite edição de tipo de entidades");
      @acesso.save    
    end
    unless Acesso.exists?(modulo: "Tipo Entidade", opcao: "Deletar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Tipo Entidade", :opcao => "Deletar", :acao => "tipoentidade#destroy", :descricao => "Permite exclusão de tipo de entidades");
  	  @acesso.save 
    end
  end
end
