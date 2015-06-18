class AddEntIdtoEndereco < ActiveRecord::Migration
  def change
  	  add_column :enderecos, :entidade_id, :integer
  end
end
