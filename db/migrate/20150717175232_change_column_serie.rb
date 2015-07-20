class ChangeColumnSerie < ActiveRecord::Migration
  def change
  	change_column :series, :modelo, :string
  	change_column :series, :ambiente, :string
  end
end
