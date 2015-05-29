class AddNivelAcess < ActiveRecord::Migration
  def change
  	create_table :nivelacesso do |t|
	    t.string :descricao
	    t.integer :adm_id
    end
  end
end
