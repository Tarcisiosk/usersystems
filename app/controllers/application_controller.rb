class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

	before_action :configure_permitted_parameters, if: :devise_controller?
	#after_action :has_emp, only: [:create]

	after_action :save_user_empresa, only: [:update]
	after_action :setAdmin, only: [:create, :save_angular]	
	
	before_filter :set_current_emp_if_first, only: [:index]
	
	before_filter :check_acesso_routes, only: [:index, :new, :edit, :destroy, :statusset]
	before_filter :check_if_is_not_using, only: [:destroy, :statusset]

	helper_method :menu
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
	helper_method :returnAllEstados
	helper_method :returnClassFisc
	helper_method :returnEmpresas
	helper_method :statusset
	
	@@checked_rows = []
	@@checked_users = []
	@@checked_empresas = []

	def after_sign_in_path_for(resource)
		'/index'
	end

	def render_validation_errors(model)
	  render :json => { :errors => model.errors }, status: 422
	end


	def menuMovimentos(i)
		movMenu = Array.new
		if i == 0
			movEntradas = Tipomovimentacao.where("tipo='Entrada'");
			movEntradas.each_with_index do |item, index|
				movMenu[index] = {:label => item.descricao, :path => '/movimentoms/' + item.id.to_s, :acao => 'movimentom#index'}
			end	
		elsif i == 1
			movSaidas = Tipomovimentacao.where("tipo='Saída'");
			movSaidas.each_with_index do |item, index|
				movMenu[index] = {:label => item.descricao, :path => '/movimentoms/' + item.id.to_s, :acao => 'movimentom#index'}
			end	
		else i == 2
			movOutros = Tipomovimentacao.where("tipo='Outros'");
			movOutros.each_with_index do |item, index|
				movMenu[index] = {:label => item.descricao, :path => '/movimentoms/' + item.id.to_s, :acao => 'movimentom#index'}
			end	
		end
		return movMenu
	end

	def menu
		menuBuilder = {:maincadastros => {:label=>'Cadastros', 
										  :tipo_entidade => {:label=>'Empresas e Contatos',
														 		:tipos =>{:label => 'Tipos', :path => '/tipoentidades', :acao =>'tipoentidade#index'}, 
																:entidades =>{:label => 'Empresas/Contatos', :path => '/entidades', :acao =>'entidade#index'}}, 
										  
										  :cadastros => {:label=>'Produtos', 
														 	:grupos =>{:label => 'Grupos', :path => '/grupos', :acao =>'grupo#index'}, 
														 	:subgrupos =>{:label => 'Sub-Grupos', :path => '/subgrupos', :acao =>'subgrupo#index'},
	 														:unidades =>{:label => 'Unidades', :path => '/unidades', :acao =>'unidade#index'},
										 				  	:produtos => {:label=> 'Produtos', :path => '/produtos', :acao =>'produto#index'}, 
														 	:classificacaofiscals =>{:label => 'Classific. Fiscais', :path => '/classificacaofiscal', :acao => 'classificacaofiscal#index'}}},	   
				       
				       :mainmovimentacoes => {:label=>'Movimentações', 
				       						  :entrada =>{:label=>'Entradas', },
				       						  :saida =>{:label=>'Saídas',  },
				       						  :outro =>{:label=>'Outros',  }},
				       :mainfinanceiro => {:label=>'Financeiro',
				       					   :cadastros=>{:label=>'Cadastros',
				       					   				:planocontas =>{:label=>'Plano de Contas', :path=>'/planocontas', :acao =>'planoconta#index'}},
				       					   :financeiro=>{:label=>'Financeiro',
				       					   				 :contacorrentes=>{:label=>'Conta Corrente', :path=>'/contacorrentes', :acao=>'contacorrentes#index'}}},
				       :configuracoes => {:label=>'Configurações', 
						 				  
						 				  :configuracoes => {label:"Cadastros", 
											 				  	:empresas => {:label=> 'Empresas', :path => '/empresas', :acao =>'empresa#index'}, 
											 				  	:nivelacesso => {:label=> 'Nivel Acesso', :path => '/nivelacesso', :acao =>'nivelacesso#index'},
											 				  	:serie => {:label=> 'Séries', :path => '/series', :acao =>'serie#index'},
										 				        :tipomovimentacao => {:label=> 'Tipos de Mov.', :path => '/tipomovimentacaos', :acao =>'tipomovimentacao#index'}, 
											 				  	:usuarios =>{:label=> 'Usuários', :path => '/users', :acao=>'user#index'}}},					   				 
				       :mainadministracao => {:label=>'Administração', 
				       						  :cadastros =>{:label=>'Cadastros', 
				       						  				:estado =>{:label =>'Estados', :path=>'/estados', :acao=>'estado#index'},
				       						  				:icmsinterestadual =>{:label =>'ICMS Interestadual', :path=>'/icmsinterestadual', :acao=>'icmsinterestadual#index'},
				       						  				:cfop =>{:label =>'CFOP', :path=>'/cfops', :acao=>'cfop#index'}}}}
		
		menuMovimentos(0).each do |item|
			if item
				menuBuilder[:mainmovimentacoes][:entrada][item[:label].to_sym] = item
			end
		end

		menuMovimentos(1).each do |item|
			if item
				menuBuilder[:mainmovimentacoes][:saida][item[:label].to_sym] = item
			end
		end

		menuMovimentos(2).each do |item|
			if item
				menuBuilder[:mainmovimentacoes][:outro][item[:label].to_sym] = item
			end
		end
		if current_user.user_type != 0
			menuBuilder.except!(:mainadministracao)
		end	

		if current_user.user_type == 2
			menuBuilder.each do |hkey, hvalue|
				if hvalue.is_a?(Hash)
					hvalue.each do |subkey, subvalue|
						if subvalue.is_a?(Hash)
							subvalue.each  do |optkey, optvalue|
								if optvalue.is_a?(Hash)
									if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao(optvalue[:acao]))
									else
										subvalue.except!(optkey)
									end
								end 
							end
							if subvalue.except(:label).empty?
								hvalue.except!(subkey)
							end
						end
					end
					if hvalue.except(:label).empty?
						menuBuilder.except!(hkey)
					end
				end
			end
			menuBuilder
		else
			menuBuilder
		end
	end

	def statusset
		obj = instance_variable_get("@" + controller_name.downcase)
		obj = (controller_name.capitalize).constantize.find(params[:id])

		if obj.status == 'a'
			obj.status = 'i'

		elsif obj.status == 'i'
			obj.status = 'a'
		end

		obj.usuarioalterador = current_user.email
		obj.dataalteracao = DateTime.now
		obj.save

		if obj.save
			redirect_to  :action => "index"
		end
	end

	def check_if_is_not_using
		if controller_name != "sessions"

			obj = instance_variable_get("@" + controller_name.downcase)
			obj = (controller_name.capitalize).constantize.find(params[:id])

			if controller_name == 'tipoentidade'
				Entidade.all.each do |item|
					if item.status == 'a'
						if item.tipoentidades.include?(obj)
							flash[:notice] = 'Este tipo de empresa/contato está sendo utilizado em uma empresa/contato e não pode ser inativado/deletado.'
							redirect_to :action => "index" and return
						end
					end
				end
			elsif controller_name == 'entidade'
				Movimentom.all.each do |item|
					if item.entidade_id == obj.id
						flash[:notice] = 'Esta empresa/contato está sendo utilizado(a) em um movimento e não pode ser inativado/deletado.'
						redirect_to :action => "index" and return
					end
				end
				Contacorrente.all.each do |item|
					if item.entidade_id == obj.id
						flash[:notice] = 'Esta empresa/contato está sendo utilizado(a) em uma conta corrente e não pode ser inativado/deletado.'
						redirect_to :action => "index" and return
					end
				end
			elsif controller_name == 'grupo'
				Subgrupo.all.each do |item|
					if item.status == 'a'
						if item.grupo_id == obj.id
							flash[:notice] = 'Este grupo está sendo utilizado em um subgrupo e não pode ser inativado/deletado.'
							redirect_to :action => "index" and return
						end
					end
				end
				Produto.all.each do |item|
					if item.status == 'a'
						if item.grupo_id == obj.id
							flash[:notice] = 'Este grupo está sendo utilizado em um produto e não pode ser inativado/deletado.'
							redirect_to :action => "index" and return
						end
					end
				end 
			elsif controller_name == 'subgrupo'
				Produto.all.each do |item|
					if item.status == 'a'
						if item.subgrupo_id == obj.id
							flash[:notice] = 'Este subgrupo está sendo utilizado em um produto e não pode ser inativado/deletado.'
							redirect_to :action => "index" and return
						end
					end
				end 
			elsif controller_name == 'unidade'
				Produto.all.each do |item|
					if item.status == 'a'
						if item.grupo_id == obj.id
							flash[:notice] = 'Este subgrupo está sendo utilizado em um produto e não pode ser inativado/deletado.'
							redirect_to :action => "index" and return
						end
					end
				end 
			elsif controller_name == 'produto'
				Movimentom.all.each do |item|
					if item.produtos_list.include?('"id":' + obj.id.to_s)
		 				flash[:notice] = 'Este produto está sendo utilizado em um movimento e não pode ser inativado/deletado.'
						redirect_to :action => "index" and return
					end
				end
			elsif controller_name == 'classificacaofiscal'
				Produto.all.each do |item|
					if item.status == 'a'
						if item.classificacaofiscal_id == obj.id
							flash[:notice] = 'Esta classificação fiscal está sendo utilizada em um produto e não pode ser inativada/deletada.'
							redirect_to :action => "index" and return
						end
					end
				end 		
			end	
		end
	end

	#seta adm para itens criados
	def setAdmin
		obj = instance_variable_get("@" + controller_name.downcase)

		if controller_name != "sessions"

			#se usuario for master os usuarios criados(master/adm) serão adm de si 
			if current_user.user_type == 0					
				if obj.attributes.key?('adm_id')
					if obj.is_a?(User)
						obj.adm_id = obj.id			
					else
						obj.adm_id = current_user.settings(:last_empresa).edited.adm_id						
					end
				end

			elsif current_user.user_type == 1
				if obj.attributes.key?('adm_id')
					if obj.is_a?(User) || obj.is_a?(Empresa)
						obj.adm_id = current_user.adm_id			
					else
						obj.adm_id = current_user.settings(:last_empresa).edited.adm_id						
					end
				end

			#se o usuario for comum os usuarios criados(comuns) serão administrados pelo seu administrador
			elsif current_user.user_type == 2
				if obj.attributes.key?('adm_id')
					if obj.is_a?(User) || obj.is_a?(Empresa)
						obj.adm_id = current_user.adm_id			
					else
						obj.adm_id = current_user.settings(:last_empresa).edited.adm_id						
					end
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

			#puts "CHECKED ROWS: #{@@checked_rows}"
			if @@checked_rows == [] || @@checked_rows.blank?
				if controller_name == "user"
					#user
					obj.empresas.each_with_index  do |item ,index|
						item.users.delete(obj)
					end
					obj.settings(:last_empresa).edited = nil
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
							#item.users << obj
							obj.empresas << @@checked_empresas[index]
							obj.settings(:last_empresa).edited = nil
						elsif controller_name == "empresa"
							if index == 0
								obj.users.clear
								item.empresas.delete(obj)
							end	
							#item.empresas << obj
							obj.users << @@checked_empresas[index]
						end				
						item.save!
						obj.save!									
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
			end 
		elsif controller_name == "empresa"
			params[:users].each_with_index do |item, index|
				@@checked_rows[index] = User.find(item.to_i)
			end
		end
		respond_to do |format| 
	        format.html { render nothing: true }
	        format.js { render nothing: true }
   		end
	end

	def redirect_login_if_user_nil
		if current_user.nil?
			redirect_to root_path
		end			
	end

	#seta a empresa atual se não houver nenhuma selecionada
	def set_current_emp_if_first		
		if current_user.settings(:last_empresa).edited.blank? && lastEmpTable.present?
			current_user.settings(:last_empresa).edited = lastEmpTable.first
		end		
	end

	#retorna classificação Fiscaç
	def returnClassFisc
		classFisc = Array.new
		Classificacaofiscal.all.each do |cf|
			if cf.adm_id == current_user.adm_id
				if cf.status == 'a'				
					classFisc << cf
				end
			end
		end
		render :json =>(classFisc.sort_by{|e| e[:descricao]}).to_json.to_s.html_safe
	end

	#retorna eestados
	def returnAllEstados
		estados = Array.new
		Estado.all.each do |item|
			estados << item
		end
		render :json => estados.to_json.to_s.html_safe
	end

	#retorna empresas
	def returnEmpresas
		empresas = Array.new
		Empresa.all.each do |item|
			if item.adm_id == current_user.settings(:last_empresa).edited.adm_id
				empresas << item
			end
		end
		render :json =>(empresas.sort_by{|e| e[:nome_fantasia]}).to_json.to_s.html_safe
	end

	#retorna items que pertencem/sao acessiveis ao usuario
	def returnItensUsuario
		obj = instance_variable_get("@" + controller_name.downcase)
		itensUser = Array.new
		if controller_name == "subgrupo"
			Grupo.all.each do |item|				
				if item.empresas.include?(current_user.settings(:last_empresa).edited) && item.adm_id == current_user.settings(:last_empresa).edited.adm_id	
					if item.status == 'a'				
						itensUser << item					
					end
				end
			end
		end
		if controller_name == "entidade"
			Tipoentidade.all.each do |item|
				if current_user.user_type != 0
					if item.adm_id == current_user.settings(:last_empresa).edited.adm_id || item.adm_id == current_user.id
						if item.status == 'a'				
							itensUser << item					
						end
					end
				else
					if item.adm_id == current_user.settings(:last_empresa).edited.adm_id
						if item.status == 'a'				
							itensUser << item					
						end
					end
				end
			end
		end
		respond_to do |format|
   			format.js { render :json => itensUser.to_json.to_s.html_safe }
    		format.html { return itensUser }
   		end
	end

	protected
	#configurações das tables e dados enviados.
	#colunas ativas
	def act_columns
		if (current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col.include?({:sTitle => 'Opções', :bSortable => false, :width => '80px'}))
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col - [{:sTitle => 'Opções', :bSortable => false, :width => '80px'}]
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
		if (current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col.include?({:sTitle => 'Opções', :bSortable => false, :width => '80px'}))
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col
		else	
			current_user.settings(("columns_" + controller_name.classify.downcase).to_sym).col << {:sTitle => 'Opções', :bSortable => false, :width => '80px'}
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
		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:fullname, :email, :password, :password_confirmation, :current_password, :n_acesso, :columns_user, :columns_empresa, :photo, :api_key) }
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
		default_content.compact!
		default_content.sort_by! &:nome_fantasia
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
	

	#retorna niveis de acesso
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

	def check_acesso_routes
		action = controller_name + "#" + action_name 
		if controller_name != "sessions" && controller_name != "index" && controller_name != "nivelacesso" && current_user.user_type == 2
			unless current_user.nivelacesso.acessos.include?(Acesso.find_by_acao(action))
				redirect_to notAllowed_path
			end
		end

		if controller_name == "estado" || controller_name =="cfop"
			unless current_user.user_type == 0
				redirect_to notAllowed_path
			end
		end
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
			redirect_to notAllowed_path
		end
	end
	
	#requer acesso adm
	def require_adm_acess
		unless current_user.user_type == 1
			redirect_to notAllowed_path
		end
	end

	#requer acesso master ou adm
	def require_master_or_adm_acess
		if controller_name != "sessions"
			unless current_user.user_type == 0 || current_user.user_type == 1
				respond_to do |format|
					format.html { redirect_to notAllowed_path}
				end
			end
		end
	end
	#fim autenticações e permissões

end
