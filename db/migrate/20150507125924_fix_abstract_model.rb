class FixAbstractModel < ActiveRecord::Migration
  def change
    remove_column :users, :adm_id
    remove_column :empresas, :adm_id
  	create_table :AbstractRecords do |t|
      	t.string :type
      	t.string :adm_id
  	end
  end
end
