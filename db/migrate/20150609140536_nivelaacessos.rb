class Nivelaacessos < ActiveRecord::Migration
  def change
  	  	rename_table :nivelacesso_users, :nivelacessos_users
  end
end
