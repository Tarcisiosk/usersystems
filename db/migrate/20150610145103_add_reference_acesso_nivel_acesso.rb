class AddReferenceAcessoNivelAcesso < ActiveRecord::Migration
  def change
  	 create_table :acessos_nivelacessos do |t|
      t.references :acesso, :nivelacesso
    end
  end
end
