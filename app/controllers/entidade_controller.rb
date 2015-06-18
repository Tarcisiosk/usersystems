class EntidadeController < ApplicationController

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contato?'}}]
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Entidade, act_columns_final, entidade_actions, view_context, current_user) }
		end
	end

	def show
		@entidade = Entidade.find(params[:id])
	end

	def new
		@entidade = Entidade.new
	end

	def create
		@entidade = Entidade.new(entidade_params)
		respond_to do |format|
			if @entidade.save
				format.html { redirect_to entidades_path, notice: ' ' }
				format.json { render :show, status: :created, location: @entidade }
			else
				format.html { render :new }
				format.json { render json: @entidade.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@entidade = Entidade.find(params[:id]) 
		#@entidade.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end

	end

	def update
		@entidade = Entidade.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @entidade.update(entidade_params)
				format.html { redirect_to entidades_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @entidade }
			else
				format.html { render :edit }
				format.json { render json: @entidade.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@entidade = Entidade.find(params[:id])
		@entidade.destroy
		if @entidade.destroy
			redirect_to entidades_path, notice: " "
		end
	end

	def entidade_params
		params.require(:entidade).permit(:id, :razao_social, :users, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :adm_id)
	end

	def  
	end

	def entidade_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contatos?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contato?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contato?'}}]
		end
	end
end
