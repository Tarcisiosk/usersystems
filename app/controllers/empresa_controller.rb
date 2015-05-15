class EmpresaController < ApplicationController

	before_filter :require_adm_or_common_acess!, only: [:create]

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]  
	
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Empresa, act_columns_final, @@actions, view_context, current_user) }
		end
	end

	def show
		@empresa = Empresa.find(params[:id])
	end

	def new
		@empresa = Empresa.new
	end

	def create
		if current_user.id == 1
			redirect_to root_path, notice: "Você não tem permissão para isso!"
		else
			@empresa = Empresa.new(empresa_params)
			respond_to do |format|
				if @empresa.save
					format.html { redirect_to empresas_path, notice: ' ' }
					format.json { render :show, status: :created, location: @empresa }
				else
					format.html { render :new }
					format.json { render json: @empresa.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	def edit
		@empresa = Empresa.find(params[:id]) 
		@empresa.users.each do |item|
			puts "usuario ligados a essa empresa: #{item.fullname}"
		end
	end

	def update
		@empresa = Empresa.find(params[:id]) 
		respond_to do |format|
			if @empresa.update(empresa_params)
				format.html { redirect_to empresas_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @empresa }
			else
				format.html { render :edit }
				format.json { render json: @empresa.errors, status: :unprocessable_entity }
			end
		end
	end

	def empresa_params
		params.require(:empresa).permit(:id, :razao_social, :users, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :endereco, :rua, :num_rua, :complemento, :bairro, :uf, :cep)
	end

	def require_adm_or_common_acess!
		unless current_user.user_type == 1 || current_user.user_type == 2
			redirect_to empresas_path, notice: "Você não tem permissão para isso!"
		end
	end


end
