class AdjustConfitela < ActiveRecord::Migration
  def change
  	add_column :conf_tela, :table_act_columns, :text
  end
end
