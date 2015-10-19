class AddFlagToProdutos < ActiveRecord::Migration
  def change
  	add_column :produtos, :industrializado, :bool, :default => false
  end
end
