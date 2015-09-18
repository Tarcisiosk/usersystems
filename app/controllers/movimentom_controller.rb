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
		@cliente = ''
		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")		
		@ipicst = Ipicst.all.select("id","codigo","descricao").where('codigo >= 50')
		@icmscst = Icmscst.all.select("id", "codigo", "descricao")
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao").order(id: :asc)
		@icmssupersimple = Icmssupersimple.all.select("id", "codigo", "descricao")
		@@angularActions = {:data => '', :entidade_id => '', :consumidor_final => false, :produtos_list => '', :totalvalor => 0, :totalquantidade => 0}
		render :edit
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
		@cliente = Entidade.find(@movimentom.entidade_id)
		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")		
		@ipicst = Ipicst.all.select("id","codigo","descricao").where('codigo >= 50')
		@icmscst = Icmscst.all.select("id", "codigo", "descricao").order(id: :asc)
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao").order(id: :asc)
 		@icmssupersimple = Icmssupersimple.all.select("id", "codigo", "descricao")
		@@angularActions = {:data => @movimentom.data.strftime("%d/%m/%Y"), :entidade_id => @movimentom.entidade_id, :consumidor_final => @movimentom.consumidor_final, :produtos_list => @movimentom.produtos_list, :totalvalor => @movimentom.totalvalor, :totalquantidade => @movimentom.totalquantidade}

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
			@movimentom.totalvalor = data_hash[:totalvalor]
			@movimentom.totalquantidade = data_hash[:totalquantidade]
			@movimentom.consumidor_final = data_hash[:consumidor_final]
		else
			@movimentom = Movimentom.new(data: data_hash[:data], entidade_id: data_hash[:entidade_id], consumidor_final: data_hash[:consumidorfinal] ,produtos_list: data_hash[:produtos_list], totalvalor: data_hash[:totalvalor], totalquantidade: data_hash[:totalquantidade], adm_id: current_user.settings(:last_empresa).edited.adm_id)
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
			if produto.adm_id == current_user.settings(:last_empresa).edited.adm_id && produto.classificacaofiscal_id >= 1 && produto.empresas.include?(current_user.settings(:last_empresa).edited)
				unless produtos_array.include?(produto)
					produtos_array << produto
				end
			end	
		end
 		render :json => produtos_array.to_json.to_s.html_safe
	end

	def returnIcms
		@produto = Produto.find(params[:id])
		if params[:ent] == 'true'
			if Entidade.find(params[:ent_id]).enderecos.any?
				@estado = Estado.find_by_uf(Endereco.find( Entidade.find(params[:ent_id]).enderecos.first.id ).uf)
			else
				@estado = Estado.find_by_uf(params[:uf])
			end
		else
			@estado = Estado.find_by_uf(params[:uf])
		end
		if @produto.personalizado
			icms = Icmsproduto.where(produto_id: params[:id], estado_id: @estado.id)
		else

			icms = Classificacaofiscal.find(@produto.classificacaofiscal_id).icmsclassificacaofiscals.where(classificacaofiscal_id: @produto.classificacaofiscal_id, estado_id: @estado.id)
		end
		render :json => icms.to_json.to_s.html_safe
	end
	
	def returnIcmsInterEstadual
		if Icmsinterestadual.where(origem: params[:or], destino: params[:dest])
			icms = Icmsinterestadual.where(origem: params[:or], destino: params[:dest])
		else
			icms = Classificacaofiscal.find(@produto.classificacaofiscal_id).icmsclassificacaofiscals.where(classificacaofiscal_id: @produto.classificacaofiscal_id)
		end
		render :json => icms.to_json.to_s.html_safe
	end
	
	def returnAliqPisCofins
		@produto = Produto.find(params[:id])
		cf = Classificacaofiscal.find(@produto.classificacaofiscal_id)
		aliqpiscofins = Array.new
		if cf.pisdaempresa == true
			aliqPis = current_user.settings(:last_empresa).edited.aliquotapis
		else
			aliqPis = cf.pis_aliquota 
		end

		if cf.cofinsdaempresa == true
			aliqCofins = current_user.settings(:last_empresa).edited.aliquotaconfins
		else
			aliqCofins = cf.cofins_aliquota
		end
		aliqpiscofins << aliqPis
		aliqpiscofins << aliqCofins
		render :json => aliqpiscofins.to_json.to_s.html_safe
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