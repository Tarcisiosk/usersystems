class AddDataIcmsSuperSimples < ActiveRecord::Migration
  def change
  	unless Icmssupersimple.exists?(codigo: 102)
      @icmssupersimple = Icmssupersimple.new(:codigo => 102, :descricao => "Tributada pelo Simples Nacional sem permissão de crédito")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 103)
       @icmssupersimple = Icmssupersimple.new(:codigo => 103, :descricao => "Isenção do ICMS no Simples Nacional para faixa de receita bruta")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 201)
       @icmssupersimple = Icmssupersimple.new(:codigo => 201, :descricao => "Tributada pelo S.N. com permissão de crédito e com cobrança do ICMS por subst. trib.")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 202)
       @icmssupersimple = Icmssupersimple.new(:codigo => 202, :descricao => "Tributada pelo S.N. sem permissão de crédito e com cobrança do ICMS por subst. trib.")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 203)
       @icmssupersimple = Icmssupersimple.new(:codigo => 203, :descricao => "Isenção do ICMS no S.N. para faixa de receita bruta e com cobr. do ICMS por subs.trib.")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 300)
       @icmssupersimple = Icmssupersimple.new(:codigo => 300, :descricao => "Imune")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 400)
       @icmssupersimple = Icmssupersimple.new(:codigo => 400, :descricao => "Não tributada pelo Simples Nacional")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 500)
       @icmssupersimple = Icmssupersimple.new(:codigo => 500, :descricao => "ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação")
       @icmssupersimple.save
    end
    unless Icmssupersimple.exists?(codigo: 900)
       @icmssupersimple = Icmssupersimple.new(:codigo => 900, :descricao => "Outros")
       @icmssupersimple.save
    end
 
  end
end
