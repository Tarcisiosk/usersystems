class CreateIcmsinterestaduals < ActiveRecord::Migration
  def change
    create_table :icmsinterestaduals do |t|
      t.integer :origem
      t.integer :destino
      t.float :icms

      t.timestamps null: false
    end
  end
end
