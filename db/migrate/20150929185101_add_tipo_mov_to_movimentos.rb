class AddTipoMovToMovimentos < ActiveRecord::Migration
  def change
  		add_column :movimentoms, :id_tipomovimentacao, :integer
  end
end
