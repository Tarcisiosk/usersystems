class ChangePisCstToString < ActiveRecord::Migration
  def change
  	  	change_column :piscofinscsts, :codigo,  :string

  end
end
