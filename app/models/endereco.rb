class Endereco < AbstractRecord
	belongs_to :entidade

	validates :tipo_endereco, presence: true
	validates :rua, presence: true
	validates :num_rua, numericality: true, presence: true
	validates :cep, numericality: true, presence: true, length: { in: 8..8 }

end
