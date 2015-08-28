class AddOrigemFieldToProdutos < ActiveRecord::Migration
  def change
  	add_column :produtos, :origem_id, :integer
  end
end
