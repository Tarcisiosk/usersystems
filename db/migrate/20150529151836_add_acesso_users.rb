class AddAcessoUsers < ActiveRecord::Migration
  def change
  	add_column :users, :n_acesso, :string, default: "Padrão"
  end
end
