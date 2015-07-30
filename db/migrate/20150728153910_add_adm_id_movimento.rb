class AddAdmIdMovimento < ActiveRecord::Migration
  def change
  
 	unless Acesso.exists?(modulo: "Movimentação", opcao: "Visualizar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Movimentação", :opcao => "Visualizar", :acao => "movimentom#index", :descricao => "Permite visualização de movimentação")
    	@acesso.save
    end
    unless Acesso.exists?(modulo: "Movimentação", opcao: "Criar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Movimentação", :opcao => "Criar", :acao => "movimentom#new", :descricao => "Permite criação de movimentação");
      	@acesso.save
    end
    unless Acesso.exists?(modulo: "Movimentação", opcao: "Editar")
    	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Movimentação", :opcao => "Editar", :acao => "movimentom#edit", :descricao => "Permite edição de movimentação");
      	@acesso.save    
    end
    unless Acesso.exists?(modulo: "Movimentação", opcao: "Deletar")
      	@acesso = Acesso.new(:id => Acesso.maximum(:id).next, :modulo => "Movimentação", :opcao => "Deletar", :acao => "movimentom#destroy", :descricao => "Permite exclusão de movimentação");
  	  	@acesso.save 
    end

    add_column :movimentoms, :adm_id, :integer

  end
end
