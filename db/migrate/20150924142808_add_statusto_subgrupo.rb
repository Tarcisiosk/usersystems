class AddStatustoSubgrupo < ActiveRecord::Migration
  def change
  	add_column :subgrupos, :status, :string, :default => 'a'
    add_column :subgrupos, :usuarioalterador, :string
	add_column :subgrupos, :dataalteracao, :datetime
  end
end
