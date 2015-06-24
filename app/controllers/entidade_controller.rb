class EntidadeController < ApplicationController

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contato?'}}]
	
	@@angularActions = {:razao_social => '', :nome_fantasia => '', :cnpj => '', :insc_estadual => '', :insc_municipal => '', 
						:tipoentidades => [], :empresas => [],
						:endereco => [{:rua => '', :num_rua => '', :cep => '', :uf => '', :cidade => '', :bairro => ''}]}
	
	helper_method :send_json

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
		
		@@angularActions = {:razao_social => @entidade.razao_social, :nome_fantasia => @entidade.nome_fantasia, :cnpj => @entidade.cnpj, :insc_estadual => @entidade.insc_estadual, :insc_municipal => @entidade.insc_municipal, 
						:tipoentidades => @entidade.tipoentidades.pluck(:id), :empresas => @entidade.empresas.pluck(:id),
						:endereco => [{:rua => '', :num_rua => '', :cep => '', :uf => '', :cidade => '', :bairro => ''}]}

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
		params.require(:entidade).permit(:razao_social, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :users, :tipoentidades, :empresas, :adm_id)
	end

	def send_json
		return @@angularActions.to_json
	end
	
	def save_angular
		@entidade = Entidade.find(params[:id])
		data_hash = params[:data].symbolize_keys
		data_hash[:endereco] = data_hash[:endereco].symbolize_keys
		
		array_empresas = []
		array_tipos = []
		array_enderecos = []

		@entidade.razao_social = data_hash[:razao_social]
		@entidade.nome_fantasia = data_hash[:nome_fantasia]
		@entidade.cnpj = data_hash[:cnpj]
		@entidade.insc_estadual = data_hash[:insc_estadual]
		@entidade.insc_estadual = data_hash[:insc_municipal]
		
		if data_hash[:empresas].present?
			data_hash[:empresas].each do |item|
				if item.present? && item != "false"
					if Empresa.find(item).adm_id == current_user.adm_id
						array_empresas << Empresa.find(item)
					end
				end
			end
		end

		if data_hash[:tipoentidades].present?
			data_hash[:tipoentidades].each do |item|
				if item.present? && item != "false"
					if Tipoentidade.find(item).adm_id == current_user.adm_id
						array_tipos << Tipoentidade.find(item)
					end
				end
			end
		end

		if data_hash[:endereco].present?
			data_hash[:endereco].each do |item|
				item.each do |subitem|
					if subitem.is_a?(Hash)
						array_enderecos << Endereco.new(rua: subitem[:rua], num_rua: subitem[:num_rua], bairro: subitem[:bairro], cep: subitem[:cep], cidade: subitem[:cidade], uf: subitem[:uf], adm_id: current_user.adm_id)
					end
				end
			end
		end

		@entidade.empresas = array_empresas
		@entidade.tipoentidades = array_tipos
		@entidade.enderecos = array_enderecos
		puts "ENDERECOS!!!!: #{array_enderecos}"

		@entidade.save!

		redirect_to entidades_path
	end

	def entidade_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contatos?'}}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#edit'))
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
