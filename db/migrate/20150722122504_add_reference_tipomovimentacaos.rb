class AddReferenceTipomovimentacaos < ActiveRecord::Migration
  def change
  	add_column :tipomovimentacaos, :empresa_id, :integer, references: :empresa
  end
end
