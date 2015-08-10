class AddDataIpiCsts < ActiveRecord::Migration
  def change
  	unless Ipicst.exists?(codigo: "0")
      @ipicst = Ipicst.new(:codigo => "0", :descricao => "Entrada Tributada")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "1")
      @ipicst = Ipicst.new(:codigo => "1", :descricao => "Entrada Tributável com Alíquota Zero")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "2")
      @ipicst = Ipicst.new(:codigo => "2", :descricao => "Entrada Isenta")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "3")
      @ipicst = Ipicst.new(:codigo => "3", :descricao => "Entrada Não-Tributada")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "4")
      @ipicst = Ipicst.new(:codigo => "4", :descricao => "Entrada Imune")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "5")
      @ipicst = Ipicst.new(:codigo => "5", :descricao => "Entrada com Suspensão")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "49")
      @ipicst = Ipicst.new(:codigo => "49", :descricao => "Outras Entradas")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "50")
      @ipicst = Ipicst.new(:codigo => "50", :descricao => "Saída Tributada")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "51")
      @ipicst = Ipicst.new(:codigo => "51", :descricao => "Saída Tributável com Alíquota Zero")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "52")
      @ipicst = Ipicst.new(:codigo => "52", :descricao => "Saída Isenta")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "53")
      @ipicst = Ipicst.new(:codigo => "53", :descricao => "Saída Não-Tributada")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "54")
      @ipicst = Ipicst.new(:codigo => "54", :descricao => "Saída Imune")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "55")
      @ipicst = Ipicst.new(:codigo => "55", :descricao => "Saída com Suspensão")
      @ipicst.save
    end
    unless Ipicst.exists?(codigo: "99")
      @ipicst = Ipicst.new(:codigo => "99", :descricao => "Outras Saídas")
      @ipicst.save
    end
  end
end