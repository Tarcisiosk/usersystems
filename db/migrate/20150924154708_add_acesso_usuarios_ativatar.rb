class AddAcessoUsuariosAtivatar < ActiveRecord::Migration
  def change
  	unless Acesso.exists?(modulo: "Tipo Entidade", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Tipo Entidade", :opcao => "Inativar", :acao => "tipoentidade#statusset", :descricao => "Permite Inativação/Ativação de tipo de entidades");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Entidade", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Unidade", :opcao => "Inativar", :acao => "entidade#statusset", :descricao => "Permite Inativação/Ativação de entidades");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Grupo", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Grupo", :opcao => "Inativar", :acao => "grupo#statusset", :descricao => "Permite Inativação/Ativação de grupos");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Subgrupo", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Subgrupo", :opcao => "Inativar", :acao => "subgrupo#statusset", :descricao => "Permite Inativação/Ativação de subgrupos");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Unidades", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Unidades", :opcao => "Inativar", :acao => "tipoentidade#unidade", :descricao => "Permite Inativação/Ativação de unidades");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Produtos", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Produtos", :opcao => "Inativar", :acao => "produto#statusset", :descricao => "Permite Inativação/Ativação de produtos");
  	  @acesso.save 
    end
    unless Acesso.exists?(modulo: "Classificação Fiscal", opcao: "Inativar")
      @acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Classificação Fiscal", :opcao => "Inativar", :acao => "Classificacaofiscal#statusset", :descricao => "Permite Inativação/Ativação de classificação fiscal");
  	  @acesso.save 
    end
  end
end
