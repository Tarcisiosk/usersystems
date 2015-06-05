class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :require_master_or_adm_acess, only: [:destroy]

	after_action :save_user_empresa, only: [:update]
	after_action :setAdmin, only: [:create]

	before_filter :set_current_emp_if_first, only: [:index]

	helper_method :getName
	helper_method :act_columns
	helper_method :inact_columns
	helper_method :act_columns_final
	helper_method :lastEmpTable
	helper_method :empTable
	helper_method :userTable
	helper_method :editingUser
	helper_method :save_user_empresa
	helper_method :returnItensUsuario
	helper_method :returnNiveisAcesso

	@@checked_rows = []
	@@checked_users = []
	@@checked_empresas = []

	def after_sign_in_path_for(resource)
		'/index'
	end

	#seta adm para itens criados
	def setAdmin
		if controller_name != "sessions"
			obj = instance_variable_get("@" + controller_name.downcase)
			if controller_name == "user"
				#se usuario for master os usuarios criados(master/adm) serão adm de si 
				if current_user.user_type == 0
					obj.adm_id = obj.id
				#se usuario for adm os usuarios criados(comuns) serão administrados pelo criador 
				elsif current_user.user_type == 1
					obj.adm_id = current_user.id
				#se o usuario for comum os usuarios criados(comuns) serão administrados pelo seu administrador
				else
					obj.adm_id = current_user.adm_id
				end
			else
				#se usuario for master os usuarios criados(master/adm) serão adm de si 
				if current_user.user_type == 1
					obj.adm_id = current_user.adm_id
				#se o usuario for comum os usuarios criados(comuns) serão administrados pelo seu administrador
				elsif current_user.user_type == 2
					obj.adm_id = current_user.adm_id
				end
			end
			if obj.save
				obj.save!
			end
		end
	end

	#salva configurações dee coluna do usuario
	def save_settings
		new_pref = Array.new
		params[("columns_" + controller_name.classify.downcase).to_sym].each_with_index do |item, index|
			new_pref[index] = eval(item)
		end 
		current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col = new_pref
		current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).save!
		
		if current_user.settings(("columns_" + controller_name.classify.downcase).to_sym)
			redirect_to :action => "index"
		else
			redirect_to :action => "index"
		end
	end

	#salva empresas na quais usuario comum tem acesso
	def save_user_empresa
		obj = instance_variable_get("@" + controller_name.downcase)
		ActiveRecord::Base.transaction do

			puts "CHECKED ROWS: #{@@checked_rows}"
			if @@checked_rows == [] || @@checked_rows.blank?
				if controller_name == "user"
					#user
					obj.empresas.each_with_index  do |item ,index|
						item.users.delete(obj)
					end
					obj.empresas.clear
				elsif controller_name == "empresa"
					#user
					obj.users.each_with_index  do |item ,index|
						item.empresas.delete(obj)
					end
					obj.users.clear
				end
			else
				@@checked_rows.each_with_index do |item, index|
					@@checked_users[index] = obj
					@@checked_empresas[index] = item

					if obj.adm_id == item.adm_id
						if controller_name == "user"
						
							if index == 0
								obj.empresas.clear
								item.users.delete(obj)
							end
							item.users << obj
							obj.empresas << @@checked_empresas[index]
						elsif controller_name == "empresa"
	
							if index == 0
								obj.users.clear
								item.empresas.delete(obj)
							end	
							item.empresas << obj
							obj.users << @@checked_empresas[index]
						end

						obj.save!
						item.save!
					end
				end
			end
		end
	end

	#retorna colunas marcadas para relação usuario/empresa
	def checked_rows
		@@checked_rows.clear
		@@checked_users.clear
		@@checked_empresas.clear
		if controller_name == "user"
			params[:empresas].each_with_index do |item, index|
				@@checked_rows[index] = Empresa.find(item.to_i)
				puts "CHECKED ROW: #{@@checked_rows[index].nome_fantasia}"
			end 
		elsif controller_name == "empresa"
			params[:users].each_with_index do |item, index|
				@@checked_rows[index] = User.find(item.to_i)
				puts "CHECKED ROW: #{@@checked_rows[index].fullname}"
			end
		end
		respond_to do |format| 
	        format.html { render nothing: true }
	        format.js { render nothing: true }
   		end
	end

	#seta a empresa atual se não houver nenhuma selecionada
	def set_current_emp_if_first
		if current_user.settings(:last_empresa).edited.blank? && lastEmpTable.present?
			current_user.settings(:last_empresa).edited = lastEmpTable.first
		end
	end

	protected
	#configurações das tables e dados enviados.
	#colunas ativas
	def act_columns
		if (current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col.include?({:sTitle => 'Opções', :bSortable => false, :width => '40px'}))
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col - [{:sTitle => 'Opções', :bSortable => false, :width => '40px'}]
		else
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col
		end
	end
	#colunas inatiaas
	def inact_columns
		(controller_name.capitalize).constantize::total((controller_name.capitalize).constantize.const_get("TOTAL_COLUMNS_"+ controller_name.classify.upcase)) - current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col
	end

	#linhas com a coluna opçoes para mandar para o generalDatatabme 
	def act_columns_final
		if (current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col.include?({:sTitle => 'Opções', :bSortable => false, :width => '40px'}))
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col
		else	
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col << {:sTitle => 'Opções', :bSortable => false, :width => '40px'}
		end
	end

	#pega nomes para impressao na view
	def getName(col)
		name_columns = []
		col.each_with_index do |item, index|
			if item.has_key?("sTitle".to_sym)
				name_columns[index] = item.slice(:sTitle).values[0]
			end
		end
		name_columns
	end
	#fim configurações
	
	#parametros usuario devise
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:fullname, :email, :password, :password_confirmation, :remember_me) }
		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:fullname, :email, :password, :password_confirmation, :current_password, :n_acesso, :columns_user, :columns_empresa, :photo) }
	end

	#empresas disponiveis para seleção
	def lastEmpTable
		obj = instance_variable_get("@" + controller_name.downcase)
		default_content = []
		Empresa.all.each_with_index do |item, index|
			if current_user.user_type == 1
				if item.adm_id == current_user.adm_id || item.adm_id == current_user.id
					default_content[index] = item
				end
			elsif current_user.user_type == 2
				if (item.adm_id == current_user.adm_id || item.adm_id == current_user.id) && (item.users.include? current_user) 
					default_content[index] = item
				end
			else
				default_content[index] = item
			end
		end
		default_content.compact
	end

	#empresaa para o adm dar acesso ao usuario comum
	def empTable
		obj = instance_variable_get("@" + controller_name.downcase)
		default_content = []
		Empresa.all.each_with_index do |item, index|
			if current_user.user_type != 0
				if item.adm_id == current_user.adm_id || item.adm_id == current_user.id
					default_content[index] = item
				end
			else
				default_content[index] = item
			end
		end
		(default_content.compact).sort!
	end

	#usuarios para o adm ligar a empresas
	def userTable
		obj = instance_variable_get("@" + controller_name.downcase)
		default_content = []
		User.all.each_with_index do |item, index|
			if current_user.user_type != 0
				if (item.adm_id == current_user.adm_id || item.adm_id == current_user.id) && item.user_type == 2
					default_content[index] = item
				end
			else
				if (item.adm_id == obj.adm_id) && item.user_type == 2
					default_content[index] = item
				end
			end
		end
		default_content.compact
	end

	#usuario a ser editado
	def editingUser
		obj = instance_variable_get("@" + controller_name.downcase)
	end

	#retorna items que pertencem/sao acessiveis ao usuario
	def returnItensUsuario
		obj = instance_variable_get("@" + controller_name.downcase)
		itensUser = Array.new
		if controller_name == "subgrupo"
			Grupo.all.each do |item|
				if current_user.user_type != 0
					if item.adm_id == current_user.adm_id || item.adm_id == current_user.id
						itensUser << item
					end
				else
					if item.adm_id == obj.adm_id
						itensUser << item
					end
				end
			end
		end
		return itensUser
	end

	def returnNiveisAcesso
		niveis = Array.new
		obj = instance_variable_get("@" + controller_name.downcase)
		Nivelacesso.all.each do |item|
			if item.adm_id == current_user.adm_id || item.adm_id == current_user.id
				niveis << item
			else
				if item.adm_id == obj.adm_id
					niveis << item
				end
			end
		end
		return niveis
	end

	#---->> Fim funções <<----#
	
	#pemissões e autenticações
	def authenticate_user!
		if user_signed_in?
			super
		else
			redirect_to root_path
		end
	end

	#requer acesso master
	def require_master_acess
		unless current_user.user_type == 0 
			redirect_to "/422", notice: "Você não tem permissão para isso!"
		end
	end
	
	#requer acesso adm
	def require_adm_acess
		unless current_user.user_type == 1
			redirect_to "/422", notice: "Você não tem permissão para isso!"
		end
	end

	#requer acesso master ou adm
	def require_master_or_adm_acess
		if controller_name != "sessions"
			unless current_user.user_type == 0 || current_user.user_type == 1
				respond_to do |format|
					format.html { redirect_to "/422", notice: "Você não tem permissão para isso!"}
				end
			end
		end
	end

	#seta o adm_id do master igual ao adm_id do obj enquanto ele estiver sendo editado
	def setMasterAdmin
		obj = instance_variable_get("@" + controller_name.downcase)
		#se o usuario for master e estiver editando um usuario qualquer o adm_id do master será igual ao adm_id do usuario editado
		if current_user.user_type == 0
			current_user.adm_id = obj.adm_id
		end	
	end

	#retorna papra o adm_id original do master
	def backMasterAdmin
		if current_user.user_type == 0
			current_user.adm_id = (current_user.id).to_s
		end
		current_user.save!
	end
	#fim autenticações e permissões

end
