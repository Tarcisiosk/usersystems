class AddDefaults < ActiveRecord::Migration
  def change
  	change_column :produtos, :frete, :float, :default => 0
  	change_column :produtos, :desconto, :float, :default => 0
  	change_column :produtos, :seguro, :float, :default => 0
  	change_column :produtos, :outros, :float, :default => 0
  end
end
