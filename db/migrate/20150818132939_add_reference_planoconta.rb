class AddReferencePlanoconta < ActiveRecord::Migration
  def change
  	add_column :planoconta, :empresa_id, :integer, references: :empresa
  end
end
