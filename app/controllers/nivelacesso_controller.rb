class NivelacessoController < ApplicationController
	# @@actions = [{:caption => 'Configurar', :method_name => :get, :class_name => 'btn blue btn-xs ', :action => 'configurar'},
	# 			 {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
	# 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o nivel de acesso?'}}]
@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
			{:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
	
	def index
		if current_user.user_type != 2
			respond_to do |format|
				format.html
				format.json { render json: GeneralDatatable.new(Nivelacesso.where("status != 'x'"), act_columns_final, @@actions, view_context, current_user) }
			end
		else
			respond_to do |format|
				format.html { redirect_to  notAllowed_path}
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

	def configurar		
		@nivelacesso = Nivelacesso.find(params[:id]) 
	end

	def destroy
		@nivelacesso = Nivelacesso.find(params[:id])
		@nivelacesso.status = 'x'
		@nivelacesso.save
		if @nivelacesso.status == 'x'
			redirect_to nivelacessos_path, notice: " "
		end
	end

	def act_acesso
		@nivelacesso = Nivelacesso.find(params[:id])
		acessoAux = Acesso.find(params[:acesso])
		
		if @nivelacesso.acessos.include?(acessoAux)
		else
			@nivelacesso.acessos << acessoAux
		end

		@nivelacesso.save!
		redirect_to nivelacessos_path
	end

	def deact_acesso
		@nivelacesso = Nivelacesso.find(params[:id])
		acessoAux = Acesso.find(params[:acesso])

		if @nivelacesso.acessos.include?(acessoAux)
			@nivelacesso.acessos.delete(acessoAux)
		else
		end
		
		@nivelacesso.save!
		redirect_to nivelacessos_path
	end

	def nivelacesso_params
		params.require(:nivelacesso).permit(:id, :descricao, :adm_id, :acessos, :users)
	end 

end
