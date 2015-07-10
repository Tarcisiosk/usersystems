class AddReferencesIcmsinterestadual < ActiveRecord::Migration
  def change
  	change_column :icmsinterestaduals, :origem, :integer, references: :estados, index: true
  	change_column :icmsinterestaduals, :destino, :integer, references: :estados, index: true
  end
end
