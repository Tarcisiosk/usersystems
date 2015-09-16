class CreateContacorrentes < ActiveRecord::Migration
  def change
    create_table :contacorrentes do |t|
      t.date :data
      t.float :debito
      t.float :credito
      t.float :saldo
      t.string :documento
      t.string :descricao
      t.references :entidade

      t.timestamps null: false
    end
  end
end
