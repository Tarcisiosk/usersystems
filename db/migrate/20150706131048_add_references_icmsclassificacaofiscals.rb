class AddReferencesIcmsclassificacaofiscals < ActiveRecord::Migration
  def change
  	change_column :icmsclassificacaofiscals, :classificacaofiscal_id, :integer, references: :classificacaofiscals, index: true
  	change_column :icmsclassificacaofiscals, :estado_id, :integer, references: :estados, index: true
  end
end
