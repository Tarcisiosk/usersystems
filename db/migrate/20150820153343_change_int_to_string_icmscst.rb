class ChangeIntToStringIcmscst < ActiveRecord::Migration
  def change
  	change_column :icmscsts, :codigo,  :string
  end
end
