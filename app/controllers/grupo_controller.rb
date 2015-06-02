class GrupoController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o grupo e seus subgrupos?'}}]

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Grupo, act_columns_final, @@actions, view_context, current_user) }
		end
	end

	def show
		@grupo = Grupo.find(params[:id])
	end

	def new
		@grupo = Grupo.new
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
		#@grupo.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end

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

	def grupo_params
		params.require(:grupo).permit(:descricao, :adm_id)
	end 
end
