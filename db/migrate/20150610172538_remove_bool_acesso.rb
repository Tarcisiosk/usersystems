class RemoveBoolAcesso < ActiveRecord::Migration
  def change
  	  	remove_column :acessos , :permissao, :datetime
  end
end
