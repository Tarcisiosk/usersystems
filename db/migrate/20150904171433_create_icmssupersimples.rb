class CreateIcmssupersimples < ActiveRecord::Migration
  def change
    create_table :icmssupersimples do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps null: false
    end
  end
end
