class EstadoController < ApplicationController
	
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o estado?'}}]
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Estado, act_columns_final, @@actions, view_context, current_user) }
		end
	end

	def show
		@estado = Estado.find(params[:id])
	end

	def new
		@estado = Estado.new
	end

	def create
		@estado = Estado.new(estado_params)
		respond_to do |format|
			if @estado.save
				format.html { redirect_to estados_path, notice: ' ' }
				format.json { render :show, status: :created, location: @estado }
			else
				format.html { render :new }
				format.json { render json: @estado.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@estado = Estado.find(params[:id]) 
		#@grupo.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end

	end

	def update
		@estado = Estado.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @estado.update(estado_params)
				format.html { redirect_to estados_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @estado }
			else
				format.html { render :edit }
				format.json { render json: @estado.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@estado = Estado.find(params[:id])	
		if @estado.destroy
				redirect_to estados_path, notice: " "
		end
	end

	def estado_params
		params.require(:estado).permit(:id, :codigo_ibge, :uf, :descricao, :icms_interno, :diferimento)
	end 

end
