class CreateConfUsers < ActiveRecord::Migration
  	def change
		create_table :conf_tela do |t|
	    	t.string :sTitle
	    	t.string :data_name
	   		t.string :width
			t.boolean :bSortable
			t.boolean :bSearchable
		end
  	end
end
