class AddAdmidSerie < ActiveRecord::Migration
  def change
  	add_column :series, :adm_id, :integer
  end
end
