class AddFlagToProdutos < ActiveRecord::Migration
  def change
  	add_column :produtos, :industrializado, :bool, :default => true
  end
end
