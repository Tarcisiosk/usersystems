class AddDataPisCofinsCsts < ActiveRecord::Migration
  def change
  	unless Piscofinscst.exists?(codigo: "1")
      @piscofinscst = Piscofinscst.new(:codigo => "1", :descricao => "Operação Tributável com Alíquota Básica.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "2")
      @piscofinscst = Piscofinscst.new(:codigo => "2", :descricao => "Operação Tributável com Alíquota Diferenciada.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "3")
      @piscofinscst = Piscofinscst.new(:codigo => "3", :descricao => "Operação Tributável com Alíquota por Unidade de Medida de Produto.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "4")
      @piscofinscst = Piscofinscst.new(:codigo => "4", :descricao => "Operação Tributável Monofásica - Revenda a Alíquota Zero.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "5")
      @piscofinscst = Piscofinscst.new(:codigo => "5", :descricao => "Operação Tributável por Substituição Tributária.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "6")
      @piscofinscst = Piscofinscst.new(:codigo => "6", :descricao => "Operação Tributável a Alíquota Zero.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "7")
      @piscofinscst = Piscofinscst.new(:codigo => "7", :descricao => "Operação Isenta da Contribuição.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "8")
      @piscofinscst = Piscofinscst.new(:codigo => "8", :descricao => "Operação sem Incidência da Contribuição.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "9")
      @piscofinscst = Piscofinscst.new(:codigo => "9", :descricao => "Operação com Suspensão da Contribuição.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "49")
      @piscofinscst = Piscofinscst.new(:codigo => "49", :descricao => "Outras Operações de Saída.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "50")
      @piscofinscst = Piscofinscst.new(:codigo => "50", :descricao => "Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "51")
      @piscofinscst = Piscofinscst.new(:codigo => "51", :descricao => "Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "52")
      @piscofinscst = Piscofinscst.new(:codigo => "52", :descricao => "Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "53")
      @piscofinscst = Piscofinscst.new(:codigo => "53", :descricao => "Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "54")
      @piscofinscst = Piscofinscst.new(:codigo => "54", :descricao => "Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "55")
      @piscofinscst = Piscofinscst.new(:codigo => "55", :descricao => "Operação com Direito a Crédito - Vinculada a Receitas Não Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "56")
      @piscofinscst = Piscofinscst.new(:codigo => "56", :descricao => "Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "60")
      @piscofinscst = Piscofinscst.new(:codigo => "60", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "61")
      @piscofinscst = Piscofinscst.new(:codigo => "61", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "62")
      @piscofinscst = Piscofinscst.new(:codigo => "62", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "63")
      @piscofinscst = Piscofinscst.new(:codigo => "63", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "64")
      @piscofinscst = Piscofinscst.new(:codigo => "64", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "65")
      @piscofinscst = Piscofinscst.new(:codigo => "65", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "66")
      @piscofinscst = Piscofinscst.new(:codigo => "66", :descricao => "Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "67")
      @piscofinscst = Piscofinscst.new(:codigo => "67", :descricao => "Crédito Presumido - Outras Operações.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "70")
      @piscofinscst = Piscofinscst.new(:codigo => "70", :descricao => "Operação de Aquisição sem Direito a Crédito.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "71")
      @piscofinscst = Piscofinscst.new(:codigo => "71", :descricao => "Operação de Aquisição com Isenção.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "72")
      @piscofinscst = Piscofinscst.new(:codigo => "72", :descricao => "Operação de Aquisição com Suspensão.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "73")
      @piscofinscst = Piscofinscst.new(:codigo => "73", :descricao => "Operação de Aquisição a Alíquota Zero.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "74")
      @piscofinscst = Piscofinscst.new(:codigo => "74", :descricao => "Operação de Aquisição sem Incidência da Contribuição.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "75")
      @piscofinscst = Piscofinscst.new(:codigo => "75", :descricao => "Operação de Aquisição por Substituição Tributária.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "98")
      @piscofinscst = Piscofinscst.new(:codigo => "98", :descricao => "Outras Operações de Entrada.")
      @piscofinscst.save
    end
    unless Piscofinscst.exists?(codigo: "99")
      @piscofinscst = Piscofinscst.new(:codigo => "99", :descricao => "Outras Operações.")
      @piscofinscst.save
    end
  end
end