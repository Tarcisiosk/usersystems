class GrupoController < ApplicationController
	
	@@actions = []

	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Grupo.where("status != 'x'"), act_columns_final, grupo_actions, view_context, current_user) }
		end
	end

	def show
		@grupo = Grupo.find(params[:id])
	end

	def new
		@grupo = Grupo.new
		@@angularActions = {:descricao => '', :empresas => []}
		render :edit
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
		@grupo.status = 'x'
		@grupo.save
		if @grupo.status == 'x'
			redirect_to grupos_path, notice: " "
		end

		# Subgrupo.all.each do |item|
		# 	if item.grupo_id == @grupo.id
		# 		item.destroy
		# 	end
		# end
		# @grupo.destroy
		# if @grupo.destroy
		# 		redirect_to grupos_path, notice: " "
		# end
	end

	def send_json
 		render :json => @@angularActions.to_json.to_s.html_safe
	end

	def save_angular
		data_hash = params[:data].symbolize_keys
		array_empresas = Array.new
	
		if data_hash[:empresas].present?
			data_hash[:empresas].each do |item|
				if item.present? && item != "false"
					if Empresa.find(item).adm_id == current_user.settings(:last_empresa).edited.adm_id
						array_empresas << Empresa.find(item)
					end
				end
			end
		end

		array_empresas.uniq

		if Grupo.where(:id => params[:id]).present? 
			@grupo = Grupo.find(params[:id])
			@grupo.descricao = data_hash[:descricao]
			@grupo.empresas.clear

			array_empresas.each do |empresa|
				if !@grupo.empresas.include?(empresa)
					@grupo.empresas << empresa
				end
			end
		else
			@grupo = Grupo.new(descricao: data_hash[:descricao], empresas: array_empresas, adm_id: current_user.settings(:last_empresa).edited.adm_id)
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
		@@actions = []
		if current_user.user_type == 2
			
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#edit'))
				@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
			end
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#destroy')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('grupo#statusset'))
				@@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}
			end
			if @@actions == []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
		end
		return @@actions
	end 

end
