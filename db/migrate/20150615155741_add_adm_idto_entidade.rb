class AddAdmIdtoEntidade < ActiveRecord::Migration
  def change
  	add_column :entidades, :adm_id, :integer
  end
end
