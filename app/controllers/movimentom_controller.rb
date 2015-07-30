class MovimentomController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir a movimentação?'}}]
	
	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Movimentom, act_columns_final, movimentom_actions, view_context, current_user) }
		end
	end

	def show
		@movimentom = Movimentom.find(params[:id])
	end

	def new
		@movimentom = Movimentom.new
		@@angularActions = {:data => '', :entidade_id => '', :produtos_list => ''}

	end

	def create
		@movimentom = Movimentom.new(movimentom_params)
		respond_to do |format|
			if @movimentom.save
				format.html { redirect_to movimentoms_path, notice: ' ' }
				format.json { render :show, status: :created, location: @movimentom }
			else
				format.html { render :new }
				format.json { render json: @movimentom.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@movimentom = Movimentom.find(params[:id]) 
		@@angularActions = {:data => @movimentom.data, :entidade_id => @movimentom.entidade_id, :produtos_list => @movimentom.produtos_list}

	end

	def update
		@movimentom = Movimentom.find(params[:id]) 
		#se usuario a editar for master não permite alterar o tipo / Se o usuario logado não for master não permite mudar o tipo de outros usuarios
		respond_to do |format|
			if @movimentom.update(movimentom_params)
				format.html { redirect_to movimentoms_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @movimentom }
			else
				format.html { render :edit }
				format.json { render json: @movimentom.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@movimentom = Movimentom.find(params[:id])
		@movimentom.destroy
		if @movimentom.destroy
				redirect_to movimentoms_path, notice: " "
		end
	end

	def send_json
 		render :json => @@angularActions.to_json.to_s.html_safe
	end

	def save_angular
		data_hash = params[:data].symbolize_keys

		if Movimentom.where(:id => params[:id]).present? 
			@movimentom = Movimentom.find(params[:id])
			@movimentom.data = data_hash[:data]
			@movimentom.entidade_id = data_hash[:entidade_id]
			@movimentom.produtos_list = data_hash[:produtos_list]
		else
			@movimentom = Movimentom.new(data: data_hash[:data], entidade_id: data_hash[:entidade_id], produtos_list: data_hash[:produtos_list], adm_id: current_user.settings(:last_empresa).edited.adm_id)
		end
	
		@movimentom.save

		if @movimentom.valid?
			render :index
		else
		 	render json: @movimentom.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def returnEntidadeMovimentos
		entidades_array =  Array.new

		Entidade.all.each do |entidade|
			if entidade.adm_id == current_user.settings(:last_empresa).edited.adm_id
				unless entidades_array.include?(entidade)
					entidades_array << entidade
				end
			end	
		end
 		render :json => entidades_array.to_json.to_s.html_safe
	end

	def returnProdutosMovimentos
		produtos_array =  Array.new

		Produto.all.each do |produto|
			if produto.adm_id == current_user.settings(:last_empresa).edited.adm_id
				unless produtos_array.include?(produto)
					produtos_array << produto
				end
			end	
		end
 		render :json => produtos_array.to_json.to_s.html_safe
	end

	def movimentom_params
		params.require(:movimentom).permit(:data, :entidade_id, :adm_id)
	end

	def movimentom_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('movimentom#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('movimentom#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
				 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o movimentom?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('movimentom#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('movimentom#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o movimentom?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o movimentom?'}}]
		end
	end 

end
