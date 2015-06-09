class NivelacessoController < ApplicationController
	@@actions = [{:caption => 'Configurar', :method_name => :get, :class_name => 'btn blue btn-xs ', :action => 'configurar'},
				 {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o nivel de acesso?'}}]

	def index
		if current_user.user_type != 2
			respond_to do |format|
				format.html
				format.json { render json: GeneralDatatable.new(Nivelacesso, act_columns_final, @@actions, view_context, current_user) }
			end
		else
			respond_to do |format|
				format.html { redirect_to "/422", notice: "Você não tem permissão para isso!"}
			end
		end
	end
	def new
		@nivelacesso = Nivelacesso.new
	end

	def create
		@nivelacesso = Nivelacesso.new(nivelacesso_params)
		respond_to do |format|
			if @nivelacesso.save
				format.html { redirect_to nivelacessos_path, notice: ' ' }
				format.json { render :show, status: :created, location: @nivelacesso }
			else
				format.html { render :new }
				format.json { render json: @nivelacesso.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@nivelacesso = Nivelacesso.find(params[:id]) 
	end

	def update
		@nivelacesso = Nivelacesso.find(params[:id]) 
		respond_to do |format|
			if @nivelacesso.update(nivelacesso_params)
				format.html { redirect_to nivelacessos_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @nivelacesso }
			else
				format.html { render :edit }
				format.json { render json: @nivelacesso.errors, status: :unprocessable_entity }
			end
		end
	end

	def configurar		
		@nivelacesso = Nivelacesso.find(params[:id]) 
		#@nivelacesso.settings(:acesso).modulos = [[0, "Grupo", "Criar", "Permite a criação", false],
		#										 [1, "Grupo", "Editar", "Permite a edição", false],
		#										 [2, "Grupo", "Deletar", "Permite a exclusão", false],
		#										 [3, "Sub-Grupo", "Criar", "Permite a criação", false],
		#										 [4, "Sub-Grupo", "Editar", "Permite a edição", false],
		#										 [5, "Sub-Grupo", "Deletar", "Permite a exclusão", false],
		#										 [6, "Empresa", "Criar", "Permite a criação", false],
		#										 [7, "Empresa", "Editar", "Permite a edição", false],
		#										 [8, "Usuário", "Criar", "Permite a criação", false],
		#										 [9, "Usuário", "Editar", "Permite a edição", false],
		#										 [10, "Usuário", "Deletar", "Permite a exclusão", false]]
		#@nivelacesso.save!

	end

	def save_conf
		@nivelacesso = Nivelacesso.find(params[:id]) 
		@nivelacesso.settings(:acesso).modulos.save!
	end
	
	def destroy
		@nivelacesso = Nivelacesso.find(params[:id])
		@nivelacesso.destroy
		if @nivelacesso.destroy
			redirect_to nivelacessos_path, notice: " "
		end
	end

	def save_conf_acesso
		@nivelacesso = Nivelacesso.find(params[:id])

		@nivelacesso.settings(:acesso).modulos.each_with_index do |value, id|
			if params[:conf_acesso][id] == "true"
				value[-1] = true
			elsif params[:conf_acesso][id] == "false"
				value[-1] = false
			end
		end
		@nivelacesso.save!

		redirect_to nivelacessos_path
	end

	def nivelacesso_params
		params.require(:nivelacesso).permit(:id, :descricao, :adm_id, :acesso, :users)
	end 

end
