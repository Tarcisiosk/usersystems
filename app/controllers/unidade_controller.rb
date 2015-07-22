class UnidadeController < ApplicationController

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a unidade?'}}]
	
	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Unidade, act_columns_final, unidade_actions, view_context, current_user) }
		end
	end

	def show
		@unidade = Unidade.find(params[:id])
	end

	def new
		@unidade = Unidade.new
		@@angularActions = {:abreviacao=>'', :descricao => '', :fracionado => false, :empresas => []}

	end

	def edit
		@unidade = Unidade.find(params[:id]) 
		@@angularActions = {:abreviacao => @unidade.abreviacao, :descricao => @unidade.descricao, :fracionado => @unidade.fracionado, :empresas => @unidade.empresas.ids }
	end

	def destroy
		@unidade = Unidade.find(params[:id])
		@unidade.destroy
		if @unidade.destroy
			redirect_to unidades_path, notice: " "
		end
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
				
		if Unidade.where(:id => params[:id]).present? 
			@unidade = Unidade.find(params[:id])
			@unidade.abreviacao = data_hash[:abreviacao]
			@unidade.descricao = data_hash[:descricao]
			@unidade.fracionado = data_hash[:fracionado]
			@unidade.empresas.clear
			
			array_empresas.each do |empresa|
				@unidade.empresas << empresa
			end

		else
			@unidade = Unidade.new(abreviacao: data_hash[:abreviacao], descricao: data_hash[:descricao], fracionado: data_hash[:fracionado], empresas: array_empresas, adm_id: current_user.settings(:last_empresa).edited.adm_id)
		end
	
		@unidade.save

		if @unidade.valid?
			render :index
		else
		 	render json: @unidade.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def unidade_params
		params.require(:unidade).permit(:abreviacao, :descricao, :fracionado, :empresas, :adm_id)
	end

	def unidade_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('unidade#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('unidade#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a unidade?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('unidade#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('unidade#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a unidade?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a unidade?'}}]
		end
	end 


end
