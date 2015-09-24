class SubgrupoController < ApplicationController

	@@actions = []

	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Subgrupo.where("status != 'x'"), act_columns_final, subgrupo_actions, view_context, current_user) }
		end
	end

	def show
		@subgrupo = Subgrupo.find(params[:id])

	end

	def new
		@subgrupo = Subgrupo.new
		@@angularActions = {:descricao => '',:grupo_id =>'', :empresas => []}
		render :edit
	end

	def create
		@subgrupo = Subgrupo.new(subgrupo_params)
		respond_to do |format|
			if @subgrupo.save
				format.html { redirect_to sub_grupos_path, notice: ' ' }
				format.json { render :show, status: :created, location: @subgrupo }
			else
				format.html { render :new }
				format.json { render json: @subgrupo.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@subgrupo = Subgrupo.find(params[:id]) 
		@@angularActions = {:descricao => @subgrupo.descricao, :grupo_id => @subgrupo.grupo_id, :empresas => @subgrupo.empresas.ids }

	end

	def update
		@subgrupo = Subgrupo.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @subgrupo.update(subgrupo_params)
				format.html { redirect_to sub_grupos_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @subgrupo }
			else
				format.html { render :edit }
				format.json { render json: @subgrupo.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@subgrupo = Subgrupo.find(params[:id])
		@subgrupo.status = 'x'
		@subgrupo.save
		if @subgrupo.status == 'x'
			redirect_to sub_grupos_path, notice: " "
		end
		# @subgrupo.destroy
		# if @subgrupo.destroy
		# 		redirect_to sub_grupos_path, notice: " "
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
	
		if Subgrupo.where(:id => params[:id]).present? 
			@subgrupo = Subgrupo.find(params[:id])
			@subgrupo.descricao = data_hash[:descricao]
			@subgrupo.grupo_id = data_hash[:grupo_id]
			@subgrupo.empresas.clear

			array_empresas.each do |empresa|
				if !@subgrupo.empresas.include?(empresa)
					@subgrupo.empresas << empresa
				end
			end
		else
			@subgrupo = Subgrupo.new(descricao: data_hash[:descricao], grupo_id: data_hash[:grupo_id], empresas: array_empresas, adm_id: current_user.adm_id)
		end
		
		@subgrupo.save

		if @subgrupo.valid?
			redirect_to entidades_path
		else
		 	render json: @subgrupo.errors.full_messages, status: :unprocessable_entity 
		end

	end

	#retorna empresas do grupo
	def returnGrupoEmpresas
		empresas_array = Array.new
		@grupo = Grupo.find(params[:id])
		@grupo.empresas.each do |item|
			empresas_array << item
		end
 		render :json => (empresas_array.sort!).to_json.to_s.html_safe
	end

	def subgrupo_params
		params.require(:subgrupo).permit(:descricao, :grupo_id, :adm_id)
	end 

	def subgrupo_actions
		@@actions = []
		if current_user.user_type == 2
		
			if  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('subgrupo#edit'))
				@@actions << [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]
			end
		
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('subgrupo#destroy'))
				@@actions << [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o subgrupo?'}}]
			end
		
			if @@actions == []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
						 {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
		end
	end

end
