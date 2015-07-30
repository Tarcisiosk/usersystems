require 'securerandom'
class EmailValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
				record.errors[attribute] << (options[:message] || "não é um email")
		end
	end
end

class User < AbstractRecord
		TOTAL_COLUMNS_USER = [{:sTitle => 'Nome', :data_name => 'fullname', :bDefault => true}, 
							  {:sTitle => 'Email', :data_name => 'email', :bDefault => true},
							  {:sTitle => 'Nível de Acesso', :data_name => 'n_acesso', :bDefault => false}]

		#preferencias do usuario
		has_settings do |s|
			s.key :columns_user, :defaults => {:col => returnDefaults(User::TOTAL_COLUMNS_USER)}
			s.key :columns_empresa, :defaults => {:col => returnDefaults(Empresa::TOTAL_COLUMNS_EMPRESA)}
			s.key :columns_grupo, :defaults => {:col => returnDefaults(Grupo::TOTAL_COLUMNS_GRUPO)}
			s.key :columns_subgrupo, :defaults => {:col => returnDefaults(Subgrupo::TOTAL_COLUMNS_SUBGRUPO)}
			s.key :columns_nivelacesso, :defaults => {:col => returnDefaults(Nivelacesso::TOTAL_COLUMNS_NIVELACESSO)}
			s.key :columns_tipoentidade, :defaults => {:col => returnDefaults(Tipoentidade::TOTAL_COLUMNS_TIPOENTIDADE)}
			s.key :columns_entidade, :defaults => {:col => returnDefaults(Entidade::TOTAL_COLUMNS_ENTIDADE)}
			s.key :columns_estado, :defaults => {:col => returnDefaults(Estado::TOTAL_COLUMNS_ESTADO)}
			s.key :columns_classificacaofiscal, :defaults => {:col => returnDefaults(Classificacaofiscal::TOTAL_COLUMNS_CLASSIFICACAOFISCAL)}
			s.key :columns_produto, :defaults => {:col => returnDefaults(Produto::TOTAL_COLUMNS_PRODUTO)}
			s.key :columns_cfop, :defaults => {:col => returnDefaults(Cfop::TOTAL_COLUMNS_CFOP)}
			s.key :columns_unidade, :defaults => {:col => returnDefaults(Unidade::TOTAL_COLUMNS_UNIDADE)}
			s.key :columns_serie, :defaults => {:col => returnDefaults(Serie::TOTAL_COLUMNS_SERIE)}
			s.key :columns_tipomovimentacao, :defaults => {:col => returnDefaults(Tipomovimentacao::TOTAL_COLUMNS_TIPOMOVIMENTACAO)}
			s.key :columns_movimentom, :defaults => {:col => returnDefaults(Movimentom::TOTAL_COLUMNS_MOVIMENTOM)}

			s.key :last_empresa
		end

 		has_and_belongs_to_many :empresas
		belongs_to :nivelacesso

		devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	
		before_save{ 
			self.email = email.downcase 
			generate_api_key
		}

		validates :fullname, presence: true
		validates :email, email:true
		#validates :password, confirmation: true, :on => :create
		validates_presence_of :password_confirmation, :on => :create

		#:url => "/:attachment/:id/:style/:basename.:extension", :path => ":rails_root/public/:attachment/:id/:style/:basename.:extension"
		has_attached_file :photo, :storage => :database, :url => "/:attachment/:id/:style/:basename.:extension", :default_url => "../../public/assets/photos/original/missing.png"
		validates_attachment_size :photo, :less_than => 5.megabytes
		validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
		
		def self.find_for_authentication(conditions)
		    user = super
		    return nil if user.user_type == 2 && user.empresas.count <= 0
		    user
		end

		def generate_api_key
			self.api_key = SecureRandom.hex
		end
end
