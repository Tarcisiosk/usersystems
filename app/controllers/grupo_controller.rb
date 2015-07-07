class GrupoController < ApplicationController
	
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo e seus subgrupos?'}}]
	
	helper_method :send_json
	helper_method :returnGrupoEmpresas

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Grupo, act_columns_final, grupo_actions, view_context, current_user) }
		end
	end

	def show
		@grupo = Grupo.find(params[:id])
	end

	def new
		@grupo = Grupo.new
		@@angularActions = {:descricao => '', :empresas => []}

	end

	def create
		@grupo = Grupo.new(grupo_params)
		respond_to do |format|
			if @grupo.save
				format.html { redirect_to grupos_path, notice: ' ' }
				format.json { render :show, status: :created, location: @grupo }
			else
				format.html { render :new }
				format.json { render json: @grupo.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@grupo = Grupo.find(params[:id]) 
		@@angularActions = {:descricao => @grupo.descricao, :empresas => @grupo.empresas.ids }

	end

	def update
		@grupo = Grupo.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @grupo.update(grupo_params)
				format.html { redirect_to grupos_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @grupo }
			else
				format.html { render :edit }
				format.json { render json: @grupo.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@grupo = Grupo.find(params[:id])
		Subgrupo.all.each do |item|
			if item.grupo_id == @grupo.id
				item.destroy
			end
		end
		@grupo.destroy
		if @grupo.destroy
				redirect_to grupos_path, notice: " "
		end
	end

	def send_json
		return @@angularActions.to_json
	end

	def save_angular
		data_hash = params[:data].symbolize_keys
		array_empresas = Array.new
	
		if data_hash[:empresas].present?
			data_hash[:empresas].each do |item|
				if item.present? && item != "false"
					if Empresa.find(item).adm_id == current_user.adm_id
						array_empresas << Empresa.find(item)
					end
				end
			end
		end
				
		if Grupo.where(:id => params[:id]).present? 
			@grupo = Grupo.find(params[:id])
			@grupo.descricao = data_hash[:descricao]
			@grupo.empresas.clear

			array_empresas.each do |empresa|
				@grupo.empresas << empresa
			end
		else
			@grupo = Grupo.new(descricao: data_hash[:descricao], empresas: array_empresas, adm_id: current_user.adm_id)
		end
	
		@grupo.save

		if @grupo.valid?
			render :index
		else
		 	render json: @grupo.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def grupo_params
		params.require(:grupo).permit(:descricao, :empresas, :adm_id)
	end

	def grupo_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo e seus subgrupos?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo e seus subgrupos?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo e seus subgrupos?'}}]
		end
	end 

end
