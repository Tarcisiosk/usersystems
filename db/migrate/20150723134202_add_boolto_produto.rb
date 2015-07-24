class AddBooltoProduto < ActiveRecord::Migration
  def change
  	  	add_column :produtos, :personalizado, :bool
  		add_column :produtos, :classificacaofiscal_id, :integer
  end
end
