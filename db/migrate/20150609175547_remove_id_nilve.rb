class RemoveIdNilve < ActiveRecord::Migration
  def change
  		remove_column :nivelacessos, :user_id, :integer
  end
end
