class SubgrupoController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o subgrupo?'}}]

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Subgrupo, act_columns_final, @@actions, view_context, current_user) }
		end
	end

	def show
		@subgrupo = Subgrupo.find(params[:id])
	end

	def new
		@subgrupo = Subgrupo.new
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
		#@subgrupo.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end
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
		@subgrupo.destroy
		if @subgrupo.destroy
				redirect_to sub_grupos_path, notice: " "
		end
	end

	def subgrupo_params
		params.require(:subgrupo).permit(:descricao, :grupo_id, :adm_id)
	end 
end
