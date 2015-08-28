class AddConsumidorFinalMovimento < ActiveRecord::Migration
  def change
  	  add_column :movimentoms, :consumidor_final, :bool
  end
end
