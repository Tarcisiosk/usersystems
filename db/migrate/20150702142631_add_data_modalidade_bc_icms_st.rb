class AddDataModalidadeBcIcmsSt < ActiveRecord::Migration
  def change
  	unless Modalidadebcicmsst.exists?(codigo: "0")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "0", :descricao => "Preço tabelado ou máximo sugerido")
      @modalidadebcicmsst.save
    end
    unless Modalidadebcicmsst.exists?(codigo: "1")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "1", :descricao => "Lista Negativa (valor)")
      @modalidadebcicmsst.save
    end
    unless Modalidadebcicmsst.exists?(codigo: "2")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "2", :descricao => "Lista Positiva (valor)")
      @modalidadebcicmsst.save
    end
    unless Modalidadebcicmsst.exists?(codigo: "3")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "3", :descricao => "Lista Neutra")
      @modalidadebcicmsst.save
    end
    unless Modalidadebcicmsst.exists?(codigo: "4")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "4", :descricao => "Margem Valor Agregado (%)")
      @modalidadebcicmsst.save
    end
    unless Modalidadebcicmsst.exists?(codigo: "5")
      @modalidadebcicmsst = Modalidadebcicmsst.new(:codigo => "5", :descricao => "Pauta (valor)")
      @modalidadebcicmsst.save
    end     
  end
end