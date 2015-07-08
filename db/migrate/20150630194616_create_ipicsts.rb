class CreateIpicsts < ActiveRecord::Migration
  def change
    create_table :ipicsts do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
