class AddUserid < ActiveRecord::Migration
  def change
  	  	drop_table :nivelacessos_users
  	  	add_column :nivelacessos, :user_id, :integer
  end
end
