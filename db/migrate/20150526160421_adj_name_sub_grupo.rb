class AdjNameSubGrupo < ActiveRecord::Migration
  def change
  	    rename_table :sub_grupos, :subgrupos
  end
end
