class UserController < ApplicationController
	before_filter :authenticate_user!
	after_action :setNivelAcesso, only: [:update, :create]

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o usuario?'}}]

	helper_method :show_image

	###usuario###   
	def index
		#current_user.settings(:columns_user).col =  [{:sTitle => 'Nome', :data_name => 'fullname'}, {:sTitle => 'Email', :data_name => 'email'}]
		#current_user.settings(:columns_user).save!
 		#se não tiver adm o usuario será adm de si mesmo
 		#	current_user.adm_id = current_user.id
 		#	current_user.save!
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(User, act_columns_final, user_actions, view_context, current_user) }
		end
	end

	def show
		@user = User.find(params[:id])
	end
	
	def show_image
		@user = User.find(params[:id])
    	send_data @user.photo.file_contents, :type => @user.photo_content_type, :filename => @user.photo_file_name, :disposition => 'inline'
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				format.html { redirect_to users_path, notice: ' ' }
				format.json { render :show, status: :created, location: @user }
			else
				format.html { render :new }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@user = User.find(params[:id]) 
		#@user.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end
	end

	def update
		@user = User.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		if current_user.adm_id == @user.adm_id || current_user.id == @user.adm_id || current_user.user_type == 0
			if @user.id == 1 || (current_user.user_type == 2 && @user.user_type != 2) || (current_user.user_type == 2)
				redirect_to notAllowed_path, notice: "Você não tem permissão para isso!"
			else
				respond_to do |format|
					if @user.update(user_params)
						format.html { redirect_to users_path, notice: ' '  }
						format.json { render :show, status: :ok, location: @user }
					else
						format.html { render :edit }
						format.json { render json: @user.errors, status: :unprocessable_entity }
					end
				end
			end
		else
			redirect_to notAllowed_path, notice: "Você não tem permissão para isso!"
		end
	end

	def destroy
		@user = User.find(params[:id])
		#se usuario for master não pode ser excluido, se usuario for comum não pode excluir
		if @user.id == 1 || (current_user.user_type == 2 && @user.user_type != 2) || ((current_user.adm_id != @user.adm_id) && current_user.user_type != 0)
 			redirect_to notAllowed_path, notice: "Você não tem permissão para isso!"
 		else
			@user = User.find(params[:id])
			@user.destroy
			if @user.destroy
				redirect_to users_path, notice: " "
			end
		end
	end
	
	def set_current_emp
		@empresa = Empresa.find(params[:emp_id])
		current_user.settings(:last_empresa).edited = @empresa
		current_user.save!
		redirect_to root_path
	end

	#params users e acesso: Master = 0, Admin = 1, Comum = 2. 
	def user_params
		params.require(:user).permit(:id, :adm_id, :empresas, :nivelacesso, :user_type, :fullname, :email, :password, :password_confirmation, :n_acesso, :photo)
	end 

	def setNivelAcesso
		@user.nivelacesso = Nivelacesso.find_by_descricao(@user.n_acesso)
		unless @user.nivelacesso.users.include?(@user)
			@user.nivelacesso.users << @user
		end
	end

	def user_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('user#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('user#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o usuário?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('user#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('user#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o usuário?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o usuário?'}}]
		end
	end
	def generate_api_key
		user = User.find(params[:user][:id])
		user.generate_api_key 		
		user.save!
		redirect_to users_path
	end

end
	