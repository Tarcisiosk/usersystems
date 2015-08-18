class AddDataIcmscst < ActiveRecord::Migration
  def change
   	unless Icmscst.exists?(codigo: "00")
      @icmscst = Icmscst.new(:codigo => "00", :descricao => "Tributada Integralmente")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "10")
      @icmscst = Icmscst.new(:codigo => "10", :descricao => "Tributada e com cobrança do IMCS por substituição tributária")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "20")
      @icmscst = Icmscst.new(:codigo => "20", :descricao => "Com redução de Base de cálculo")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "30")
      @icmscst = Icmscst.new(:codigo => "30", :descricao => "Isenta ou não tributada e com cobrança do ICMS por substituição tributária")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "40")
      @icmscst = Icmscst.new(:codigo => "40", :descricao => "Isenta")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "41")
      @icmscst = Icmscst.new(:codigo => "41", :descricao => "Não tributada")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "50")
      @icmscst = Icmscst.new(:codigo => "50", :descricao => "Com suspensão")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "51")
      @icmscst = Icmscst.new(:codigo => "51", :descricao => "Com diferimento")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "60")
      @icmscst = Icmscst.new(:codigo => "60", :descricao => "ICMS cobrado anteriormente por substituição tributária")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "70")
      @icmscst = Icmscst.new(:codigo => "70", :descricao => "Com redução da base de cálculo e cobrança do ICMS por substituição tributária")
      @icmscst.save
    end
    unless Icmscst.exists?(codigo: "90")
      @icmscst = Icmscst.new(:codigo => "90", :descricao => "Outras")
      @icmscst.save
    end
  end
end
