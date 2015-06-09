class NivelUsers < ActiveRecord::Migration
  def change
  	create_table :nivelacesso_users do |t|
    	t.references :user, :nivelacesso
    end
  end
end
