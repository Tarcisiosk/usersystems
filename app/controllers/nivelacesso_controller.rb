class NivelacessoController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo?'}}]

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
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
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

	def destroy
		@nivelacesso = Nivelacesso.find(params[:id])
		@nivelacesso.destroy
		if @nivelacesso.destroy
			redirect_to nivelacessos_path, notice: " "
		end
	end

	def nivelacesso_params
		params.require(:nivelacesso).permit(:descricao, :adm_id)
	end 

end
