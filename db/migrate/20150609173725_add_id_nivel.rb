class AddIdNivel < ActiveRecord::Migration
  def change
  	add_column :users, :nivelacesso_id, :integer
  end
end
