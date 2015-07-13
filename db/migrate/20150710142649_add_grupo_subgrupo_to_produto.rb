class AddGrupoSubgrupoToProduto < ActiveRecord::Migration
  	def change
		unless Acesso.exists?(modulo: "Produto", opcao: "Visualizar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Produto", :opcao => "Visualizar", :acao => "produto#index", :descricao => "Permite visualização de produtos")
			@acesso.save
		end
		unless Acesso.exists?(modulo: "Produto", opcao: "Criar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Produto", :opcao => "Criar", :acao => "produto#new", :descricao => "Permite criação de produtos");
			@acesso.save
		end
		unless Acesso.exists?(modulo: "Produto", opcao: "Editar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Produto", :opcao => "Editar", :acao => "produto#edit", :descricao => "Permite edição de produtos");
			@acesso.save    
		end
		unless Acesso.exists?(modulo: "Produto", opcao: "Deletar")
			@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Produto", :opcao => "Deletar", :acao => "produto#destroy", :descricao => "Permite exclusão de produtos");
			@acesso.save 
		end
  		
  		add_column :produtos, :grupo_id, :integer
  		add_column :produtos, :subgrupo_id, :integer
		
		create_table :empresas_produtos do |t|
	    	t.references :empresa, :produto
	    end
  	end
end
