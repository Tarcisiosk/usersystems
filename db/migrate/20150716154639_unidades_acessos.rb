class UnidadesAcessos < ActiveRecord::Migration
  def change
  		unless Acesso.exists?(modulo: "Unidade", opcao: "Visualizar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "unidade", :opcao => "Visualizar", :acao => "unidade#index", :descricao => "Permite visualização de unidades")
			@acesso.save
		end
		unless Acesso.exists?(modulo: "Unidade", opcao: "Criar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "unidade", :opcao => "Criar", :acao => "unidade#new", :descricao => "Permite criação de unidades");
			@acesso.save
		end
		unless Acesso.exists?(modulo: "Unidade", opcao: "Editar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "unidade", :opcao => "Editar", :acao => "unidade#edit", :descricao => "Permite edição de unidades");
			@acesso.save    
		end
		unless Acesso.exists?(modulo: "Unidade", opcao: "Deletar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "unidade", :opcao => "Deletar", :acao => "unidade#destroy", :descricao => "Permite exclusão de unidades");
			@acesso.save 
		end

  end
end
