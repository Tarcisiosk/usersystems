class Serie < AbstractRecord
	TOTAL_COLUMNS_SERIE = [{:sTitle => 'Série', :data_name => 'serie', :bDefault => true},
							  {:sTitle => 'Modelo', :data_name => 'modelo', :bDefault => true}]
  belongs_to :empresa, dependent: :destroy

  validates :serie, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999}
  validates :modelo, presence: true
  validates :ultima_nota_fiscal, presence: true, numericality: true
  validates :ambiente, presence: true
end
