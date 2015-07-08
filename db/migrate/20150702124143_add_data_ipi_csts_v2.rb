class AddDataIpiCstsV2 < ActiveRecord::Migration
  def change
  	Ipicst.delete_all
  	execute("ALTER SEQUENCE ipicsts_id_seq RESTART WITH 1")
  	unless Ipicst.exists?(codigo: "0")
      @ipicst = Ipicst.new(:codigo => "0", :descricao => "Entrada/Saída com Recuperação de Crédito")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "1")
      @ipicst = Ipicst.new(:codigo => "1", :descricao => "Entrada/Saída Tributável com Alíquota Zero")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "2")
      @ipicst = Ipicst.new(:codigo => "2", :descricao => "Entrada/Saída Isenta")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "3")
      @ipicst = Ipicst.new(:codigo => "3", :descricao => "Entrada/Saída Não-Tributada")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "4")
      @ipicst = Ipicst.new(:codigo => "4", :descricao => "Entrada/Saída Imune")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "5")
      @ipicst = Ipicst.new(:codigo => "5", :descricao => "Entrada/Saída com Suspensão")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "9")
      @ipicst = Ipicst.new(:codigo => "49", :descricao => "Outras Entradas/Sáidas")
      @ipicst.save
    end 
  end
end
