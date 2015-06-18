class EnderecoController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contato?'}}]
	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Endereco, act_columns_final, endereco_actions, view_context, current_user) }
		end
	end

	def show
		@endereco = Endereco.find(params[:id])
	end

	def new
		@endereco = Endereco.new
	end

	def create
		@endereco = Endereco.new(endereco_params)
		respond_to do |format|
			if @endereco.save
				format.html { redirect_to enderecos_path, notice: ' ' }
				format.json { render :show, status: :created, location: @endereco }
			else
				format.html { render :new }
				format.json { render json: @endereco.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@endereco = Endereco.find(params[:id]) 
		#@endereco.empresas.each do |item|
		# 	puts "Empresas ligadas a esse usuario: #{item.nome_fantasia}"
		#end

	end

	def update
		@endereco = Endereco.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @endereco.update(endereco_params)
				format.html { redirect_to enderecos_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @endereco }
			else
				format.html { render :edit }
				format.json { render json: @endereco.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@endereco = Endereco.find(params[:id])
		@endereco.destroy
		if @endereco.destroy
			redirect_to enderecos_path, notice: " "
		end
	end

	def endereco_params
		params.require(:endereco).permit(:rua, :num_rua, :cep, :uf, :complemento, :bairro)
	end


	def endereco_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('endereco#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('endereco#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a empresa/contatos?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('endereco#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('endereco#destroy'))
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
