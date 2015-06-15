class CreateEnderecos < ActiveRecord::Migration
  def change
    create_table :enderecos do |t|
      t.string :rua
      t.string :num_rua
      t.string :complemento
      t.string :bairro
      t.string :uf
      t.string :cep
      t.integer :adm_id
      t.string :cidade

      t.timestamps null: false
    end
  end
end
