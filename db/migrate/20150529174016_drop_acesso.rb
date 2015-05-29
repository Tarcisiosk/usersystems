class DropAcesso < ActiveRecord::Migration
  def change
  	drop_table :nivelacesso
  end
end
