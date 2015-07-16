class ProdutoController < ApplicationController
	
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
							 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o produto?'}}]
	
	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Produto, act_columns_final, produto_actions, view_context, current_user) }
		end
	end

	def show
		@produto = Produto.find(params[:id])
	end

	def show_image
		@produto = Produto.find(params[:id])
    	send_data @produto.p_photo.file_contents, :type => @produto.p_photo_content_type, :filename => @produto.p_photo_file_name, :disposition => 'inline'
	end

	def new
		@produto = Produto.new
		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")		
		@estado = Estado.all.select("id","descricao","diferimento","icms_interno").order("descricao")
		@icmsproduto = Array.new
		@estado.each do |est|
			@icmsproduto << Icmsproduto.new(estado_id: est.id, reducaobasecalculo: 0,diferimento: 0,
			aliquota: 0, icmsst: false, mva: 0, reducaomva: false)
		end	

		@@angularActions = {:descricao => '', :codigo => '', :unidade => '', :preco => '', :grupo_id => '', :subgrupo_id => '', :empresas => [], :p_photo => ''}

	end

	def create
		@produto = Produto.new(produto_params)
		respond_to do |format|
			if @produto.save
				format.html { redirect_to produtos_path, notice: ' ' }
				format.json { render :show, status: :created, location: @produto }
			else
				format.html { render :new }
				format.json { render json: @produto.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@produto = Produto.find(params[:id]) 

		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")
		@estado = Estado.all.select("id","descricao","diferimento","icms_interno").order("descricao")
		@icmsproduto = Array.new
		@estado.each do |est|			
			@icf = Icmsproduto.where("produto_id = #{@produto.id} and estado_id = #{est.id}").first			
			if @icf.nil?
				@icmsproduto << Icmsproduto.new(estado_id: est.id, reducaobasecalculo: 0,diferimento: 0, aliquota: 0, icmsst: false, mva: 0,reducaomva: false)
			else
				@icmsproduto << @icf
			end	
		end			

		@@angularActions = {:descricao => @produto.descricao, :codigo => @produto.codigo, :unidade => @produto.unidade, :preco => @produto.preco, :grupo_id => @produto.grupo_id, :subgrupo_id => @produto.subgrupo_id, :empresas => @produto.empresas.ids, :p_photo=> @produto.p_photo}

	end

	def update
		@produto = Produto.find(params[:id]) 
		respond_to do |format|
			if @produto.update(produto_params)
				format.html { redirect_to produtos_path, notice: ' ' }
				format.json { render :show, status: :ok, location: @produto }
			else
				format.html { render :edit }
				format.json { render json: @produto.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@produto = Produto.find(params[:id])
		@produto.destroy
		if @produto.destroy
				redirect_to produtos_path, notice: " "
		end
	end

	def send_json
		return @@angularActions.to_json
	end

	def save_angular
		data_hash = params[:data].symbolize_keys
		array_empresas = Array.new
	
		if data_hash[:empresas].present?
			data_hash[:empresas].each do |item|
				if item.present? && item != "false"
					if Empresa.find(item).adm_id == current_user.settings(:last_empresa).edited.adm_id
						array_empresas << Empresa.find(item)
					end
				end
			end
		end
				
		if Produto.where(:id => params[:id]).present? 
			@produto = Produto.find(params[:id])
			@produto.descricao = data_hash[:descricao]
			@produto.codigo = data_hash[:codigo]
			@produto.unidade = data_hash[:unidade]
			@produto.preco = data_hash[:preco]
			@produto.grupo_id = data_hash[:grupo_id]
			@produto.subgrupo_id = data_hash[:subgrupo_id]

			if data_hash[:p_photo] != @produto.p_photo.to_s
				@produto.p_photo = data_hash[:p_photo]
			end
			@produto.empresas.clear

			array_empresas.each do |empresa|
				@produto.empresas << empresa
			end
		else
			@produto = Produto.new(descricao: data_hash[:descricao], codigo: data_hash[:codigo], unidade: data_hash[:unidade], preco: data_hash[:preco], grupo_id: data_hash[:grupo_id], subgrupo_id: data_hash[:subgrupo_id] , p_photo: data_hash[:p_photo], empresas: array_empresas, adm_id: current_user.adm_id)
		end
	
		@produto.save


		if @produto.valid?										
			JSON.parse(params[:icmsproduto]).each do |icf|					
				if icf['produto_id'].blank?
					@icmsproduto = Icmsproduto.new(produto_id: @produto.id,estado_id: icf['estado_id'],
					reducaobasecalculo: icf['reducaobasecalculo'], diferimento: icf['diferimento'], aliquota: icf['aliquota'], icmsst: icf['icmsst'],
					modalidadebcicmsst_id: icf['modalidadebcicmsst_id'], mva: icf['mva'], reducaomva: icf['reducaomva'])												
					@icmsproduto.save
				end	
			end	
			render :index
		else
			render json: @produto.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def saveIcms
		@icf = Icmsproduto.new(params.require(:icmsproduto).permit(:id,:produto_id,:estado_id,
						:reducaobasecalculo,:diferimento,:aliquota,:icmsst,:modalidadebcicmsst_id,:mva,:reducaomva))					
		unless @icf.produto_id.blank?
			@icf = Icmsproduto.find(params[:icmsproduto][:id])							
			@icf.update(params.require(:icmsproduto).permit(:id,:produto_id,:estado_id,
						:reducaobasecalculo,:diferimento,:aliquota,:icmsst,:modalidadebcicmsst_id,:mva,:reducaomva))	
		end
		if @icf.valid?
			render :index
		else
			render json: @icf.errors.full_messages, status: :unprocessable_entity
		end			
	end

	def returnEmpresasUnidade
		empresas_array =  Array.new
		unidade_array = Array.new

		params[:empresas].each do |item|
			empresas_array << Empresa.find(item)	
		end	

		Unidade.all.each do |unidade|
			empresas_array.each do |empresa|
				if unidade.adm_id == current_user.settings(:last_empresa).edited.adm_id && unidade.empresas.include?(empresa) 
					unless unidade_array.include?(unidade)
						unidade_array << unidade
					end
				end	
			end
		end
 		render :json => unidade_array.to_json.to_s.html_safe
	end

	def returnEmpresasGrupo
		empresas_array =  Array.new
		grupo_array = Array.new

		params[:empresas].each do |item|
			empresas_array << Empresa.find(item)	
		end	

		Grupo.all.each do |grupo|
			empresas_array.each do |empresa|
				if grupo.adm_id == current_user.settings(:last_empresa).edited.adm_id && grupo.empresas.include?(empresa) 
					unless grupo_array.include?(grupo)
						grupo_array << grupo
					end
				end	
			end
		end
 		render :json => grupo_array.to_json.to_s.html_safe
	end

	def returnSubGrupoGrupo
		subgrupos_array = Array.new
		Subgrupo.all.each do |item|
			if item.grupo_id == params[:gid].to_i
				subgrupos_array << item
			end
		end		

 		render :json => subgrupos_array.to_json.to_s.html_safe
	end
	
	def produto_params
		params.require(:produto).permit(:descricao, :codigo, :unidade, :preco, :p_photo, :empresas, :grupo_id, :subgrupo_id, :adm_id)
	end

	def produto_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('produto#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('produto#destroy'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
							 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o produto?'}}]

			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('produto#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]

			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('produto#destroy'))
				@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o produto?'}}]
			
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
									 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o produto?'}}]
		end
	end 

end
