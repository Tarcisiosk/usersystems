class AddDataOrigem < ActiveRecord::Migration
  def change
  	unless Origem.exists?(codigo: "0")
      @origem = Origem.new(:codigo => "0", :descricao => "Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8")
      @origem.save
    end
    unless Origem.exists?(codigo: "1")
      @origem = Origem.new(:codigo => "1", :descricao => "Estrangeira - Importação direta, exceto a indicada no código 6")
      @origem.save
    end
    unless Origem.exists?(codigo: "2")
      @origem = Origem.new(:codigo => "2", :descricao => "Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7")
      @origem.save
    end
    unless Origem.exists?(codigo: "3")
      @origem = Origem.new(:codigo => "3", :descricao => "Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%")
      @origem.save
    end
    unless Origem.exists?(codigo: "4")
      @origem = Origem.new(:codigo => "4", :descricao => "Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos ajustes")
      @origem.save
    end
    unless Origem.exists?(codigo: "5")
      @origem = Origem.new(:codigo => "5", :descricao => "Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%")
      @origem.save
    end
    unless Origem.exists?(codigo: "6")
      @origem = Origem.new(:codigo => "6", :descricao => "Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural")
      @origem.save
    end
    unless Origem.exists?(codigo: "7")
      @origem = Origem.new(:codigo => "7", :descricao => "Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural")
      @origem.save
    end
    unless Origem.exists?(codigo: "8")
      @origem = Origem.new(:codigo => "8", :descricao => "Nacional - Mercadoria ou bem com Conteúdo de Importação superior a 70%")
      @origem.save
    end
 
  end
end
