class CreateMovimentoms < ActiveRecord::Migration
  def change
    create_table :movimentoms do |t|
      t.date :data
      t.integer :entidade_id

      t.timestamps null: false
    end
  end
end
