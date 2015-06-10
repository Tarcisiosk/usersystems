class RemoveCreateAtAcesso < ActiveRecord::Migration
  def change
  	remove_column :acessos , :created_at, :datetime
  	remove_column :acessos , :updated_at, :datetime
  end
end
