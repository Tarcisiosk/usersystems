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
							  {:sTitle => 'ID', :data_name => 'id', :bDefault => false},
							  {:sTitle => 'ADM', :data_name => 'adm_id', :bDefault => false},
							  {:sTitle => 'Tipo', :data_name => 'user_type', :bDefault => false}]

		#preferencias do usuario
		has_settings do |s|
			s.key :columns_user, :defaults => {:col => returnDefaults(User::TOTAL_COLUMNS_USER)}
			s.key :columns_empresa, :defaults => {:col => returnDefaults(Empresa::TOTAL_COLUMNS_EMPRESA)}
		end

 		has_and_belongs_to_many :empresas

		devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	
		before_save { self.email = email.downcase }
		validates :fullname, presence: true
		validates :email, email:true
		#validates :password, confirmation: true, :on => :create
		validates_presence_of :password_confirmation, :on => :create  

		has_attached_file :photo, :url => "/:attachment/:id/:style/:basename.:extension", :path => ":rails_root/public/:attachment/:id/:style/:basename.:extension"
		validates_attachment_size :photo, :less_than => 5.megabytes
		validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

end