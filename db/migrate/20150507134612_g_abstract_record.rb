class GAbstractRecord < ActiveRecord::Migration
  def change
  	create_table :AbstractRecord do |t|
      	t.string :type
      	t.string :adm_id
  	end
  end
end
