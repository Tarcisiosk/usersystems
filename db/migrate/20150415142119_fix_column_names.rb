class FixColumnNames < ActiveRecord::Migration
  def change
  	change_table :empresas do |t|
      t.rename :razaoSocial, :razao_social
      t.rename :nomeFantasia, :nome_fantasia
      t.rename :inscEstadual, :insc_estadual
      t.rename :inscMunicipal, :insc_municipal
    end
  end
end
