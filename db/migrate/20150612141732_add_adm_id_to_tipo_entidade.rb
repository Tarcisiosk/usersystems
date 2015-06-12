class AddAdmIdToTipoEntidade < ActiveRecord::Migration
  def change
  	 add_column :tipoentidades, :adm_id, :integer
  end
end
