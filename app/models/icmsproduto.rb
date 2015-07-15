class Icmsproduto < AbstractRecord
	validates :reducaobasecalculo, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
	validates :diferimento, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
	validates :aliquota, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 50}		

end
