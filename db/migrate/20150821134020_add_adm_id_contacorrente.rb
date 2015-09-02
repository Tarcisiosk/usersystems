class AddAdmIdContacorrente < ActiveRecord::Migration
  def change
  	add_column :contacorrentes, :adm_id, :integer
  end
end
