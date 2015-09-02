class DropColumnDebitoCreditoAndAddColumnValorContacorrente < ActiveRecord::Migration
  def change
  	remove_column :contacorrentes, :debito, :float
  	remove_column :contacorrentes, :credito, :float
  	add_column :contacorrentes, :valor, :float
  end
end
