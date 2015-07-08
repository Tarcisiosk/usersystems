class Icmsclassificacaofiscal < AbstractRecord

	validates :reducaobasecalculo, presence: true, numericality: { greater_than: 0, less_than: 101}
	validates :diferimento, presence: true, numericality: {greater_than: 0, less_than: 101}
	validates :aliquota, presence: true, numericality: {greater_than: 0, less_than: 51}		
end
