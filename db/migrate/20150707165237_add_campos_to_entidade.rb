class AddCamposToEntidade < ActiveRecord::Migration
  def change
    add_column :entidades, :telefone, :string
    add_column :entidades, :celular, :string
    add_column :entidades, :email, :string
  end
end
