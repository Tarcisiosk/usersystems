require 'openssl'
require 'base64'

class EmpresaController < ApplicationController

	before_filter :require_adm_or_common_acess!, only: [:create]

	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]  
	
	def index
		#current_user.settings(:last_empresa).edited = Empresa.find(11)
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Empresa, act_columns_final, empresa_actions, view_context, current_user) }
		end
	end

	def show
		@empresa = Empresa.find(params[:id])
	end

	def new
		@empresa = Empresa.new		
		@estados = Estado.all.select("uf","descricao").order("descricao")
		@userTable = userTable.to_json(include: :empresas)
		@certificadodigitals = Array.new
		render :edit
	end

	def save
		if params[:empresa][:id].blank?
			@empresa = Empresa.new(params[:empresa].symbolize_keys)
			@empresa.adm_id = current_user.adm_id
			@empresa.save			
		else			
			@empresa = Empresa.find(params[:empresa][:id])			
			@empresa.update(params[:empresa].symbolize_keys)
			save_user_empresa if current_user.user_type != 2										
		end				
		respond_to do |format|
			if @empresa.valid?
				Certificadodigital.where("empresa_id = #{@empresa.id}").delete_all
				JSON.parse(params[:certificadodigitals]).each do |cd|
					Certificadodigital.create(empresa_id: @empresa.id, cnpj: cd['cnpj'], inicio: cd['inicio'], fim: cd['fim'], 
					imagem: cd['imagem'], senha: cd['senha'], requerente: cd['requerente'])										
				end											
				format.html { render :index }
				format.json { render :show, status: :created, location: @empresa }
			else
				format.html { render json: @empresa.errors.full_messages, status: :unprocessable_entity  }
				format.json { render json: @empresa.errors.full_messages, status: :unprocessable_entity }
			end
		end
		current_user.settings(:last_empresa).edited = @empresa		
	end

	def saveCertificado				
		@content = params[:arquivo][33..params[:arquivo].length-1]
		File.open("certificado.p12", "wb") do |f|
  			f.write(Base64.decode64(@content))
		end		
		begin
			@p12 = OpenSSL::PKCS12.new(IO.binread("certificado.p12"),params[:senha])
			unless params[:empresa_id].blank?
				Certificadodigital.where("empresa_id = #{params[:empresa_id]}").each do |cd|								
					File.open("certificadodb.p12","wb") do |f|
						f.write(ActiveRecord::Base.connection.unescape_bytea(cd.imagem))
					end					
					@p12db = OpenSSL::PKCS12.new(IO.binread("certificadodb.p12"),AESCrypt.decrypt(cd.senha, cd.requerente))				
					raise 'Certificado já cadastrado' if @p12db.certificate.public_key.to_s == @p12.certificate.public_key.to_s
				end	
			end			
			raise 'O certificado está vencido' if @p12.certificate.not_after.to_date < Time.new
			@subject = @p12.certificate.subject.to_s
			@requerente = @subject[@subject.index("CN=")+3..@subject.length-1]							
			if @subject.include? ":"		
				@cnpj = @subject[@subject.index(":")+1..@subject.length-1]	
			end					
			@certificadodigital = Certificadodigital.new(cnpj: @cnpj,inicio: @p12.certificate.not_before.to_date,fim: @p12.certificate.not_after.to_date,
			imagem: ActiveRecord::Base.connection.escape_bytea(Base64.decode64(@content)), 
			senha: AESCrypt.encrypt(params[:senha], @requerente), requerente: @requerente)			
			render json: @certificadodigital.to_json			
		rescue Exception => e			
			@messages = Array.new
			if e.message.include? "mac verify failure"
				@message = "Certificado inválido ou senha incorreta"
			else
				@message = e.message	
			end	
			@messages << @message
			render json: @messages, status: :unprocessable_entity 
		end				
	end		

	def edit
		@empresa = Empresa.find(params[:id])	
		@estados = Estado.all.select("uf","descricao").order("descricao")
		@userTable = userTable.to_json(include: :empresas)
		@certificadodigitals = Certificadodigital.where("empresa_id = #{@empresa.id}")						
		current_user.settings(:last_empresa).edited = @empresa
		current_user.save!
	end

	def empresa_params
		params.require(:empresa).permit(:razao_social, :users, :nome_fantasia, :cnpj, :insc_estadual, :insc_municipal, :rua, :num_rua, :complemento, :bairro, :cidade, :uf, :cep)
	end

	def require_adm_or_common_acess!
		unless current_user.user_type == 1 || current_user.user_type == 2
			redirect_to empresas_path, notice: "Você não tem permissão para isso!"
		end
	end

	def empresa_actions
		if current_user.user_type == 2
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('empresa#edit'))
				@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]
			else
				@@actions = []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]
		end
	end

end
