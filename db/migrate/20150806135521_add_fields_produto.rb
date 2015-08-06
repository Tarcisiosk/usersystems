class AddFieldsProduto < ActiveRecord::Migration
  def change
  		add_column :produtos, :frete, :float
  		add_column :produtos, :desconto, :float
  		add_column :produtos, :seguro, :float
  		add_column :produtos, :outros, :float

  end
end
