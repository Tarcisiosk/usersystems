class Produto < AbstractRecord

	TOTAL_COLUMNS_PRODUTO = [{:sTitle => 'Descrição', :data_name => 'descricao', :bDefault => true}, 	
						  	  {:sTitle => 'Código', :data_name => 'codigo', :bDefault => true},
						      {:sTitle => 'Preço', :data_name => 'preco', :bDefault => false},
						  	  {:sTitle => 'Unidade', :data_name => 'unidade', :bDefault => false}]


	has_and_belongs_to_many :empresas
	
	validates :descricao, presence: true
	validates :codigo, presence:true, uniqueness: true

	has_attached_file :p_photo, :storage => :database, :url => "/:attachment/:id/:style/:basename.:extension", :default_url => "../../public/assets/photos/original/missing.png"
	validates_attachment_size :p_photo, :less_than => 3.megabytes
	validates_attachment_content_type :p_photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
end
