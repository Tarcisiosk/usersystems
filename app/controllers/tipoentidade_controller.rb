class TipoentidadeController < ApplicationController

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o tipo?'}}]
	
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Tipoentidade, act_columns_final, tipoentidade_actions, view_context, current_user) }
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
		@tipoentidade.destroy
		if @tipoentidade.destroy
				redirect_to tipoentidades_path, notice: " "
		end
	end

	def tipoentidade_params
		params.require(:tipoentidade).permit(:descricao, :adm_id)
	end


	def tipoentidade_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o Tipo?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipoentidade#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o Tipo?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o Tipo?'}}]
		end
	end 

end
