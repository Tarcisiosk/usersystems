class ClassificacaofiscalController < ApplicationController
	
	@@actions = []

	def index
		respond_to do |format|
			format.html
			format.json { render json: GeneralDatatable.new(Classificacaofiscal.where("status != 'x'"), act_columns_final, classificacaofiscal_actions, view_context, current_user) }
		end
	end

	def new
		@classificacaofiscal = Classificacaofiscal.new(pis_aliquota: 0, cofins_aliquota: 0, ii_aliquota: 0, ipi_aliquota: 0, adm_id: current_user.settings(:last_empresa).edited.adm_id)
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao")
		@ipicst = Ipicst.all.select("id","codigo","descricao")
		@estado = Estado.all.select("id","descricao","diferimento","icms_interno").order("descricao")
		@icmsclassificacaofiscal = Array.new
		@estado.each do |est|
			@icmsclassificacaofiscal << Icmsclassificacaofiscal.new(estado_id: est.id,reducaobasecalculo: 0, diferimento: est.diferimento,
			aliquota: est.icms_interno, aliquotafinscalculo: est.icms_interno, icmsst: false, mva: 0,reducaomva: false)
		end	
		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")		
		render :edit
	end

	def save		
		if params[:classificacaofiscal][:id].blank?
			@classificacaofiscal = Classificacaofiscal.new(params[:classificacaofiscal].symbolize_keys)					
			@classificacaofiscal.save
		else
			@classificacaofiscal = Classificacaofiscal.find(params[:classificacaofiscal][:id])
			@classificacaofiscal.update(params[:classificacaofiscal].symbolize_keys)
		end	
		respond_to do |format|
			if @classificacaofiscal.valid?										
				JSON.parse(params[:icmsclassificacaofiscals]).each do |icf|					
					if icf['classificacaofiscal_id'].blank?
						@icmsclassificacaofiscal = Icmsclassificacaofiscal.new(classificacaofiscal_id: @classificacaofiscal.id,estado_id: icf['estado_id'],
						reducaobasecalculo: icf['reducaobasecalculo'], diferimento: icf['diferimento'], aliquota: icf['aliquota'], aliquotafinscalculo: icf['aliquotafinscalculo'], icmsst: icf['icmsst'],
						modalidadebcicmsst_id: icf['modalidadebcicmsst_id'], mva: icf['mva'], reducaomva: icf['reducaomva'])												
						@icmsclassificacaofiscal.save
					end	
				end	
				format.html { render :index}
				format.json { render :show, status: :created, location: @classificacaofiscal }
			else
				format.html { render json: @classificacaofiscal.errors.full_messages, status: :unprocessable_entity }
				format.json { render json: @classificacaofiscal.errors.full_messages, status: :unprocessable_entity }
			end
		end
	end

	def saveIcms
		@icf = Icmsclassificacaofiscal.new(params.require(:icmsclassificacaofiscal).permit(:id,:classificacaofiscal_id,:estado_id,
						:reducaobasecalculo,:diferimento,:aliquota, :aliquotafinscalculo, :icmsst,:modalidadebcicmsst_id,:mva,:reducaomva))					
		unless @icf.classificacaofiscal_id.blank?
			@icf = Icmsclassificacaofiscal.find(params[:icmsclassificacaofiscal][:id])							
			@icf.update(params.require(:icmsclassificacaofiscal).permit(:id, :classificacaofiscal_id, :estado_id,
									   :reducaobasecalculo, :diferimento, :aliquota, :aliquotafinscalculo, :icmsst, :modalidadebcicmsst_id, :mva, :reducaomva))	
		end
		if @icf.valid?
			render :index
		else
			render json: @icf.errors.full_messages, status: :unprocessable_entity
		end			
	end
			
	def edit
		@classificacaofiscal = Classificacaofiscal.find(params[:id]) 
		@piscofinscst = Piscofinscst.all.select("id","codigo","descricao")
		@ipicst = Ipicst.all.select("id","codigo","descricao")
		@modalidadebcicmsst = Modalidadebcicmsst.all.select("id","codigo","descricao")
		@estado = Estado.all.select("id","descricao","diferimento").order("descricao")		
		@icmsclassificacaofiscal = Array.new
		@estado.each do |est|			
			@icf = Icmsclassificacaofiscal.where("classificacaofiscal_id = #{@classificacaofiscal.id} and estado_id = #{est.id}").first			
			if @icf.nil?
				@icmsclassificacaofiscal << Icmsclassificacaofiscal.new(estado_id: est.id, diferimento: est.diferimento, icmsst: false, reducaomva: false)				
			else
				@icmsclassificacaofiscal << @icf
			end	
		end				
	end

	def destroy
		@classificacaofiscal = Classificacaofiscal.find(params[:id])		
		@classificacaofiscal.status = 'x'
		@classificacaofiscal.save
		if @classificacaofiscal.status == 'x'
			redirect_to classificacaofiscals_path, notice: " "
		end
	end	

	def classificacaofiscal_actions
		@@actions = []
		if current_user.user_type == 2
			if  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('classificacaofiscal#edit'))
				@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
			end
			
			if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('classificacaofiscal#destroy')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('classificacaofiscal#statusset'))
				@@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}
			end
			
			if	@@actions == []
				act_columns_final.tap(&:pop)
			end
		else
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
						 {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
		end
	end

end