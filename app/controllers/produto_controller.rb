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
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao")	
		@ipicst = Ipicst.all.select("id","codigo","descricao")
		@estado = Estado.all.select("id","descricao","diferimento","icms_interno").order("descricao")
		@origem = Origem.all.select("id", "codigo", "descricao")

		@icmsproduto = Array.new
		@estado.each do |est|
			@icmsproduto << Icmsproduto.new(estado_id: est.id,reducaobasecalculo: 0, diferimento: est.diferimento,
			aliquota: est.icms_interno, aliquotafinscalculo: est.icms_interno, icmsst: false, mva: 0,reducaomva: false)
		end	

		@@angularActions = {:descricao => '', :codigo => '', :unidade => '', :preco => 0, :frete => 0, :desconto => 0, :seguro => 0, :outros => 0, :grupo_id => '', :origem_id => 1, :subgrupo_id => '', :empresas => [], :p_photo => '', :pisdaempresa => true, :cofinsdaempresa => true, :pis_cst_id => 0, :pis_aliquota => 0, :cofins_cst_id => 0, :cofins_aliquota => 0, :ii_aliquota => 0, :ipi_cst_id => 0, :ipi_aliquota => 0, :classificacaofiscal_id => '', :personalizado => false }
		render :edit
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
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao")
		@ipicst = Ipicst.all.select("id","codigo","descricao")
		@origem = Origem.all.select("id", "codigo", "descricao")

		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")
		@estado = Estado.all.select("id","descricao","diferimento","icms_interno").order("descricao")
		@icmsproduto = Array.new
		@estado.each do |est|			
			@icf = Icmsproduto.where("produto_id = #{@produto.id} and estado_id = #{est.id}").first			
			if @icf.nil?
				@icmsproduto << Icmsproduto.new(estado_id: est.id, reducaobasecalculo: 0,diferimento: 0, aliquota: 0, aliquotafinscalculo: 0, icmsst: false, mva: 0, reducaomva: false)
			else
				@icmsproduto << @icf
			end	
		end			

		@@angularActions = {:descricao => @produto.descricao, :codigo => @produto.codigo, :unidade => @produto.unidade, :preco => @produto.preco, :frete =>  @produto.frete, :desconto =>  @produto.desconto, :seguro =>  @produto.seguro, :outros =>  @produto.outros, :grupo_id => @produto.grupo_id, :origem_id => @produto.origem_id, :subgrupo_id => @produto.subgrupo_id, :empresas => @produto.empresas.ids, :p_photo=> @produto.p_photo, :classificacaofiscal_id => @produto.classificacaofiscal_id, :pisdaempresa => @produto.pisdaempresa, :cofinsdaempresa => @produto.cofinsdaempresa, :pis_cst_id => @produto.pis_cst_id, :pis_aliquota => @produto.pis_aliquota, :cofins_cst_id => @produto.cofins_cst_id, :cofins_aliquota => @produto.cofins_aliquota, :ii_aliquota => @produto.ii_aliquota, :ipi_cst_id => @produto.ipi_cst_id, :ipi_aliquota => @produto.ipi_aliquota, :personalizado => @produto.personalizado }

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
 		render :json => @@angularActions.to_json.to_s.html_safe
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
			@produto.frete = data_hash[:frete]
			@produto.desconto = data_hash[:desconto]
			@produto.seguro = data_hash[:seguro]
			@produto.outros = data_hash[:outros]
			@produto.grupo_id = data_hash[:grupo_id]
			@produto.subgrupo_id = data_hash[:subgrupo_id]
			@produto.personalizado = data_hash[:personalizado]
			@produto.pisdaempresa = data_hash[:pisdaempresa]
			@produto.cofinsdaempresa = data_hash[:cofinsdaempresa]

			@produto.origem_id = data_hash[:origem_id]

			if @produto.personalizado == true
				@produto.pis_cst_id = data_hash[:pis_cst_id]
	 			@produto.pis_aliquota = data_hash[:pis_aliquota]
				@produto.cofins_cst_id = data_hash[:cofins_cst_id]
				@produto.cofins_aliquota = data_hash[:cofins_aliquota]
				@produto.ii_aliquota = data_hash[:ii_aliquota]
				@produto.ipi_cst_id = data_hash[:ipi_cst_id]
				@produto.ipi_aliquota = data_hash[:ipi_aliquota]
			else
				@produto.classificacaofiscal_id = data_hash[:classificacaofiscal_id]
				cf = Classificacaofiscal.find(data_hash[:classificacaofiscal_id])
				@produto.pis_cst_id = cf.pis_cst_id
	 			@produto.pis_aliquota = cf.pis_aliquota
				@produto.cofins_cst_id = cf.cofins_cst_id
				@produto.cofins_aliquota = cf.cofins_aliquota
				@produto.ii_aliquota = cf.ii_aliquota
				@produto.ipi_cst_id = cf.ipi_cst_id
				@produto.ipi_aliquota = cf.ipi_aliquota
			end

			if data_hash[:p_photo] != @produto.p_photo.to_s
				@produto.p_photo = data_hash[:p_photo]
			end
			@produto.empresas.clear
			array_empresas.each do |empresa|
				if !@produto.empresas.include?(empresa)
					@produto.empresas << empresa
				end
			end
		else
			if data_hash[:personalizado] == true
				@produto = Produto.new(descricao: data_hash[:descricao], codigo: data_hash[:codigo], unidade: data_hash[:unidade], preco: data_hash[:preco], 
									  frete: data_hash[:frete], desconto: data_hash[:desconto], seguro: data_hash[:seguro], outros: data_hash[:outros], grupo_id: data_hash[:grupo_id], subgrupo_id: data_hash[:subgrupo_id] ,
									  origem_id: data_hash[:origem_id], p_photo: data_hash[:p_photo],  empresas: array_empresas, personalizado: data_hash[:personalizado], 
									  pisdaempresa: data_hash[:pisdaempresa], cofinsdaempresa: data_hash[:cofinsdaempresa], pis_cst_id: data_hash[:pis_cst_id], pis_aliquota: data_hash[:pis_aliquota], cofins_cst_id: data_hash[:cofins_cst_id], cofins_aliquota: data_hash[:cofins_aliquota], 
									  ii_aliquota: data_hash[:ii_aliquota], ipi_cst_id: data_hash[:ipi_cst_id], ipi_aliquota: data_hash[:ipi_aliquota], classificacaofiscal_id: data_hash[:classificacaofiscal_id], adm_id: current_user.adm_id)
			else
				@produto = Produto.new(descricao: data_hash[:descricao], codigo: data_hash[:codigo], unidade: data_hash[:unidade], preco: data_hash[:preco], 
										  frete: data_hash[:frete], desconto: data_hash[:desconto], seguro: data_hash[:seguro], outros: data_hash[:outros], grupo_id: data_hash[:grupo_id], subgrupo_id: data_hash[:subgrupo_id] ,
										  origem_id: data_hash[:origem_id], p_photo: data_hash[:p_photo],  empresas: array_empresas, personalizado: data_hash[:personalizado], 
										  pisdaempresa: data_hash[:pisdaempresa], cofinsdaempresa: data_hash[:cofinsdaempresa], pis_cst_id: data_hash[:pis_cst_id], pis_aliquota: data_hash[:pis_aliquota], cofins_cst_id: data_hash[:cofins_cst_id], cofins_aliquota: data_hash[:cofins_aliquota], 
										  ii_aliquota: data_hash[:ii_aliquota], ipi_cst_id: data_hash[:ipi_cst_id], ipi_aliquota: data_hash[:ipi_aliquota], classificacaofiscal_id: data_hash[:classificacaofiscal_id], adm_id: current_user.adm_id)
				
				@produto.classificacaofiscal_id = data_hash[:classificacaofiscal_id]
				cf = Classificacaofiscal.find(data_hash[:classificacaofiscal_id])
				@produto.pis_cst_id = cf.pis_cst_id
	 			@produto.pis_aliquota = cf.pis_aliquota
				@produto.cofins_cst_id = cf.cofins_cst_id
				@produto.cofins_aliquota = cf.cofins_aliquota
				@produto.ii_aliquota = cf.ii_aliquota
				@produto.ipi_cst_id = cf.ipi_cst_id
				@produto.ipi_aliquota = cf.ipi_aliquota
			end
		end
	
		@produto.save

		if @produto.valid?										
			JSON.parse(params[:icmsprodutos]).each do |icf|					
				if icf['produto_id'].blank?
					@icmsproduto = Icmsproduto.new(produto_id: @produto.id,estado_id: icf['estado_id'],
					reducaobasecalculo: icf['reducaobasecalculo'], diferimento: icf['diferimento'], aliquota: icf['aliquota'], aliquotafinscalculo: icf['aliquotafinscalculo'], icmsst: icf['icmsst'],
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
		@icf = Icmsproduto.new(params.require(:icmsproduto).permit(:id, :produto_id, :estado_id,
											:reducaobasecalculo, :diferimento, :aliquota, :aliquotafinscalculo, :icmsst, :modalidadebcicmsst_id, :mva, :reducaomva))					
		unless @icf.produto_id.blank?
			@icf = Icmsproduto.find(params[:icmsproduto][:id])							
			@icf.update(params.require(:icmsproduto).permit(:id,:produto_id,:estado_id,
						:reducaobasecalculo,:diferimento,:aliquota, :aliquotafinscalculo, :icmsst,:modalidadebcicmsst_id,:mva,:reducaomva))	
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
		grupo_opts = Array.new
		empresas_array = Array.new
		
		params[:empresas].each do |emp|
			empresas_array << Empresa.find(emp)
		end

		empresas_array.uniq!

		empresas_array.each do |emp|
			empresas_array.each do |emp2|
				if empresas_array.length > 1
					if emp != emp2
						grupo_opts = (emp.grupos.all & emp2.grupos.all)
					end
				else
					grupo_opts = emp.grupos
				end
			end
		end

		grupo_opts.each do |grupo|
			empresas_array.each do |empresa|
				if !grupo.empresas.include?(empresa)
					grupo_opts = []
				end
			end
		end

		grupo_opts.uniq

 		render :json => grupo_opts.to_json.to_s.html_safe
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
		params.require(:produto).permit(:descricao, :codigo, :unidade, :preco, :p_photo, :empresas, :grupo_id, :subgrupo_id, :personalizado, :pis_cst_id, :pis_aliquota, :cofins_cst_id, :cofins_aliquota, :ii_aliquota, :ipi_cst_id, :ipi_aliquota,:adm_id )
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
