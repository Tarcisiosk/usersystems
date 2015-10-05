class TipomovimentacaoController < ApplicationController
	@@actions = []

  def index
  	respond_to do |format|
		format.html
		format.json { render json: GeneralDatatable.new(Tipomovimentacao.where("status != 'x'"), act_columns_final, tipomovimentacao_actions, view_context, current_user) }
	end
  end

  def new	
  	@tipomovimentacao = Tipomovimentacao.new(adm_id: current_user.settings(:last_empresa).edited.adm_id,empresa_id:current_user.settings(:last_empresa).edited.id)
  	render :edit
  end

  def save
  	if params[:tipomovimentacao][:id].blank?
  		@tipomovimentacao = Tipomovimentacao.new(params[:tipomovimentacao].symbolize_keys)
  		@tipomovimentacao.save
  	else
  		@tipomovimentacao = Tipomovimentacao.find(params[:tipomovimentacao][:id])
		@tipomovimentacao.update(params[:tipomovimentacao].symbolize_keys)
  	end	
  	respond_to do |format|
		if @tipomovimentacao.valid?			
			format.html { render :index}
			format.json { render :show, status: :created, location: @tipomovimentacao }
		else
			format.html { render json: @tipomovimentacao.errors.full_messages, status: :unprocessable_entity }
			format.json { render json: @tipomovimentacao.errors.full_messages, status: :unprocessable_entity }
		end
	end
  end

  def edit
  	@tipomovimentacao = Tipomovimentacao.find(params[:id])
  end

  def destroy
	@tipomovimentacao = Tipomovimentacao.find(params[:id])	
	@tipomovimentacao.status =  'x'
	@tipomovimentacao.save	
	if @tipomovimentacao.status == 'x'
		redirect_to tipomovimentacaos_path, notice: " "
	end
  end	

  def tipomovimentacao_actions
  	 @@actions = []
 	 if current_user.user_type == 2
		if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipomovimentacao#edit'))
			@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
		end
		if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('tipomovimentacao#destroy'))
			@@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}
		else
			@@actions = []
			act_columns_final.tap(&:pop)
		end
	else
		@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
			 	     {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]

	end 
  end	
end
