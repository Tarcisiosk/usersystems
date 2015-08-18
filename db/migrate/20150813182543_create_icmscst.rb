class CreateIcmscst < ActiveRecord::Migration
  def change
    create_table :icmscsts do |t|
      	t.integer :codigo
      	t.string :descricao
      	t.timestamps null: false
    end
  end
end
