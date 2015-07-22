class CfopController < ApplicationController

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o cfop?'}}]
	
	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Cfop, act_columns_final, cfop_actions, view_context, current_user) }
		end
	end

	def show
		@cfop = Cfop.find(params[:id])
	end

	def new
		@cfop = Cfop.new
		@@angularActions = {:codigo=>'', :descricao => '', :devolucao => false}

	end

	def edit
		@cfop = Cfop.find(params[:id]) 
		@@angularActions = {:codigo => @cfop.codigo, :descricao => @cfop.descricao, :devolucao => @cfop.devolucao}
	end

	def destroy
		@cfop = Cfop.find(params[:id])
		@cfop.destroy
		if @cfop.destroy
			redirect_to cfops_path, notice: " "
		end
	end

	def send_json
 		render :json => @@angularActions.to_json.to_s.html_safe
	end

	def save_angular
		data_hash = params[:data].symbolize_keys
				
		if Cfop.where(:id => params[:id]).present? 
			@cfop = Cfop.find(params[:id])
			@cfop.codigo = data_hash[:codigo]
			@cfop.descricao = data_hash[:descricao]
			@cfop.devolucao = data_hash[:devolucao]

		else
			@cfop = Cfop.new(codigo: data_hash[:codigo], descricao: data_hash[:descricao], devolucao: data_hash[:devolucao])
		end
	
		@cfop.save

		if @cfop.valid?
			render :index
		else
		 	render json: @cfop.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def cfop_params
		params.require(:cfop).permit(:codigo, :descricao, :devolucao)
	end

	def cfop_actions
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o cfop?'}}]

	end 

end
