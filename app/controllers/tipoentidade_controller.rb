class TipoentidadeController < ApplicationController
	@@actions = []

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Tipoentidade.where("status != 'x'"), act_columns_final, tipoentidade_actions, view_context, current_user) }
		end
	end

	def show
		@tipoentidade = Tipoentidade.find(params[:id])
	end

	def new
		@tipoentidade = Tipoentidade.new
	end

	def create
		@tipoentidade = Tipoentidade.new(tipoentidade_params)
		respond_to do |format|
			if @tipoentidade.save
				format.html { redirect_to tipoentidades_path, notice: ' ' }
				format.json { render :show, status: :created, location: @tipoentidade }
			else
				format.html { render :new }
				format.json { render json: @tipoentidade.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@tipoentidade = Tipoentidade.find(params[:id]) 
	end

	def update
		@tipoentidade = Tipoentidade.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @tipoentidade.update(tipoentidade_params)
				format.html { render :index, notice: ' ' }
				format.json { render :show, status: :ok, location: @tipoentidade }
			else
				format.html { render :edit }
				format.json { render json: @tipoentidade.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@tipoentidade = Tipoentidade.find(params[:id])
		@tipoentidade.status = 'x'
		@tipoentidade.save
		if @tipoentidade.status == 'x'
			redirect_to tipoentidades_path, notice: " "
		end

		# if @tipoentidade.destroy
		# 	redirect_to tipoentidades_path, notice: " "
		# end
	end

	def tipoentidade_params
		params.require(:tipoentidade).permit(:descricao, :adm_id)
	end


	def tipoentidade_actions
		@@actions = []
		if current_user.user_type == 2	
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#edit'))
				@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
			end

			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#destroy')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#statusset')) 
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

 #{:caption => 'Inativar', :method_name => :get, :class_name => 'btn purple-medium btn-xs ', :action => 'statusset', :type => 'Status', :data => {confirm: 'Tem certeza que deseja ativar/inativar o tipo?'}},
