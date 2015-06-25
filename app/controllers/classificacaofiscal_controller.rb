class ClassificacaofiscalController < ApplicationController
	
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a classificação fiscal?'}}]
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Classificacaofiscal, act_columns_final, @@actions, view_context, current_user) }
		end
	end

	def show
		@classificacaofiscal = Classificacaofiscal.find(params[:id])
	end

	def new
		@classificacaofiscal = Classificacaofiscal.new
	end

	def create
		@classificacaofiscal = Classificacaofiscal.new(classificacaofiscal_params)		
		respond_to do |format|
			if @classificacaofiscal.save
				format.html { redirect_to classificacaofiscals_path, notice: ' ' }
				format.json { render :show, status: :created, location: @classificacaofiscal }
			else
				format.html { render :new }
				format.json { render json: @classificacaofiscal.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@classificacaofiscal = Classificacaofiscal.find(params[:id]) 
		#@grupo.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end

	end

	def update
		@classificacaofiscal = Classificacaofiscal.find(params[:id])			
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @classificacaofiscal.update(classificacaofiscal_params)
				format.html { redirect_to classificacaofiscals_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @classificacaofiscal }
			else
				format.html { render :edit }
				format.json { render json: @classificacaofiscal.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@classificacaofiscal = Classificacaofiscal.find(params[:id])		
		if @classificacaofiscal.destroy
				redirect_to classificacaofiscals_path, notice: " "
		end
	end

	def classificacaofiscal_params
		params.require(:classificacaofiscal).permit(:id, :codigo_ncm, :descricao, :adm_id, :versao)
	end 

end
