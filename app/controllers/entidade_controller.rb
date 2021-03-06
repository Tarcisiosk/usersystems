class EntidadeController < ApplicationController

	@@actions = []

	helper_method :send_json

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Entidade.where("status != 'x'"), act_columns_final, entidade_actions, view_context, current_user) }
		end
	end

	def show
		@entidade = Entidade.find(params[:id])
	end

	def new
		@entidade = Entidade.new
		@@angularActions = {:razao_social => '', :nome_fantasia => '', :cnpj => '', :insc_estadual => '', :insc_municipal => '', :email =>'' , :telefone =>'' , :celular =>'' , 
						:tipoentidades => [], :empresas => [],
						:endereco => []}
		render :edit
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
		@@angularActions = {:razao_social => @entidade.razao_social, :nome_fantasia => @entidade.nome_fantasia, :cnpj => @entidade.cnpj, :insc_estadual => @entidade.insc_estadual, :insc_municipal => @entidade.insc_municipal, :email => @entidade.email , :telefone => @entidade.telefone , :celular => @entidade.celular,
						:tipoentidades => @entidade.tipoentidades.ids, :empresas => @entidade.empresas.ids,
						:endereco => @entidade.enderecos}
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
		@entidade.status = 'x'
		@entidade.save
		if @entidade.status == 'x'
			redirect_to entidades_path, notice: " "
		end
	end

	def entidade_params
		params.require(:entidade).permit(:razao_social, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :email, :telefone, :celular, :users, :tipoentidades, :empresas, :enderecos, :adm_id)
	end

	def send_json
 		render :json => @@angularActions.to_json.to_s.html_safe
	end
	
	def save_angular
		data_hash = params[:data].symbolize_keys
		array_empresas = Array.new
		array_tipos = Array.new
		array_enderecos = Array.new

		if data_hash[:empresas].present?
			data_hash[:empresas].each do |item|
				if item.present? && item != "false"
					if Empresa.find(item).adm_id == current_user.settings(:last_empresa).edited.adm_id
						array_empresas << Empresa.find(item)
					
					end
				end
			end
		end
			

		if data_hash[:tipoentidades].present?
			data_hash[:tipoentidades].each do |item|
				if item.present? && item != "false"
					if Tipoentidade.find(item).adm_id == current_user.settings(:last_empresa).edited.adm_id
						array_tipos << Tipoentidade.find(item)
					end
				end
			end
		end

		if data_hash[:endereco].present?
			data_hash[:endereco].each do |item|
				item.each do |subitem|
					if subitem.is_a?(Hash) 
						if Endereco.where(:id => subitem['id']).present? && (subitem['tipo_endereco'].present? && subitem['rua'].present? && subitem['cep'].present? && subitem['uf'].present?)
							e = Endereco.find(subitem['id'])
							e.tipo_endereco = subitem['tipo_endereco']
							e.rua = subitem['rua']
							e.num_rua = subitem['num_rua']
							e.bairro = subitem['bairro']
							e.cidade = subitem['cidade']
							e.uf = subitem['uf']
							e.adm_id = current_user.settings(:last_empresa).edited.adm_id
							e.save!
							array_enderecos << e
						elsif subitem['rua'].present? && subitem['cep'].present? && subitem['uf'].present?
							e = Endereco.new(tipo_endereco: subitem['tipo_endereco'], rua: subitem['rua'], num_rua: subitem['num_rua'], bairro: subitem['bairro'], cep: subitem['cep'], cidade: subitem['cidade'], uf: subitem['uf'], adm_id: current_user.adm_id)
							array_enderecos << e
						else
							
						end
					end
				end
			end
		end
				
		if Entidade.where(:id => params[:id]).present? 
			@entidade = Entidade.find(params[:id])
			@entidade.razao_social = data_hash[:razao_social]
			@entidade.nome_fantasia = data_hash[:nome_fantasia]
			@entidade.cnpj = data_hash[:cnpj]
			@entidade.insc_estadual = data_hash[:insc_estadual]
			@entidade.insc_municipal = data_hash[:insc_municipal]
			@entidade.email = data_hash[:email]
			@entidade.telefone = data_hash[:telefone]
			@entidade.celular = data_hash[:celular]
			@entidade.empresas.clear
			@entidade.tipoentidades.clear

			array_empresas.each do |empresa|
				if !@entidade.empresas.include?(empresa)
					@entidade.empresas << empresa
				end
			end

			array_tipos.each do |tipo|
				if !@entidade.tipoentidades.include?(tipo)
					@entidade.tipoentidades << tipo
				end
			end
			
		else
			@entidade = Entidade.new(razao_social: data_hash[:razao_social], nome_fantasia: data_hash[:nome_fantasia], cnpj: data_hash[:cnpj], 
									 insc_estadual: data_hash[:insc_estadual], insc_municipal: data_hash[:insc_municipal], email: data_hash[:email], telefone: data_hash[:telefone], celular: data_hash[:celular] , empresas: array_empresas, 
									 enderecos: array_enderecos, tipoentidades: array_tipos, adm_id: current_user.adm_id)
		end
	
		if @entidade.insc_estadual == '' || @entidade.cnpj.mb_chars.length < 14 || !is_number?(@entidade.insc_estadual)
			@entidade.insc_estadual = 'ISENTO'
		end
		
		@entidade.enderecos = array_enderecos
		@entidade.save

		if @entidade.valid?
			redirect_to entidades_path
		else
		 	render json: @entidade.errors.full_messages, status: :unprocessable_entity 
		end
	end

	def entidade_actions
		@@actions = []
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#edit'))
				@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
			end
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#configurar')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#statusset')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('entidade#destroy'))
				@@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}

			end
			if @@actions == []
				act_columns_final.tap(&:pop)
			end
		else
			#{:caption => '<i class="fa fa-gears"></i>'.html_safe, :class_name => 'btn blue btn-xs', :id => 'Settings'},
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs', :action => 'edit'},
						 {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
		end
		return @@actions
	end
end
