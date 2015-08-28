class Planoconta < AbstractRecord
	TOTAL_COLUMNS_PLANOCONTA = [{:sTitle => 'Código', :data_name => 'codigo', :bDefault => true},
								{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}]

	belongs_to :empresa 	
	has_many :planoconta

	validates :descricao, presence: true	

	before_destroy{
		@planocontas = Planoconta.where("planoconta_id = #{self.id}")
		@planocontas.each do |placonta|
			placonta.destroy
		end	
	}

end
