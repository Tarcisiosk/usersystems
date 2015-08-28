class Icmsinterestadual < AbstractRecord
	validates :origem, presence: true
	validates :destino, presence: true
	validates :icms, presence: true, numericality: true
end
