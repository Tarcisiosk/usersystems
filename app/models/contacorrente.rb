class Contacorrente < AbstractRecord
	TOTAL_COLUMNS_CONTACORRENTE = [{:sTitle => 'Data', :data_name => 'data', :bDefault => true}, 	
						  	  {:sTitle => 'Valor', :data_name => 'valor', :bDefault => true},						    
						  	  {:sTitle => 'Saldo', :data_name => 'saldo', :bDefault => true},
						  	  {:sTitle => 'Documento', :data_name => 'documento', :bDefault => true},
						  	  {:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true},
						  	  {:sTitle => 'Status', :data_name => 'compensado', :bDefault => true}]
	belongs_to :entidade
	
	validates :data, presence: true	
	validates :valor, presence: true, numericality: true
	validates :documento, presence: true
	validates :descricao, presence: true

	def atualiza_conta_corrente			
		@contascorrentes = Contacorrente.where("entidade_id = ? and data >= ?",self.entidade_id,self.data.to_date).order("data ASC,id ASC")
		@contascorrentes.each do |cc|												
			cc.saldo = atualiza_saldo(cc)									
			cc.save
		end	
	end

	def atualiza_saldo(conta)
		@cc = Contacorrente.where("id < ? and entidade_id = ? and data = ?",conta.id,conta.entidade_id,conta.data.to_date).order("id DESC").first		
		if @cc.blank?
			@cc = Contacorrente.where("entidade_id = ? and data < ?",conta.entidade_id,conta.data.to_date).order("data DESC,id DESC").first
		end			
		if @cc.blank?								
			conta.saldo = conta.valor
		else													
			conta.saldo = conta.valor + @cc.saldo				
		end
		return conta.saldo
	end
		
end
