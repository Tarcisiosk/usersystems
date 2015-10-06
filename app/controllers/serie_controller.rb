class SerieController < ApplicationController
  @@actions = []
  
  def index
	respond_to do |format|
		format.html
		format.json { render json: GeneralDatatable.new(Serie.where("status != 'x'"), act_columns_final, serie_actions, view_context, current_user) }
	end
  end

  def new 
	@serie = Serie.new(empresa_id: current_user.settings(:last_empresa).edited.id,adm_id: current_user.settings(:last_empresa).edited.adm_id)
	render :edit
  end
  
  def save
	if params[:serie][:id].blank?
		@serie = Serie.new(params[:serie].symbolize_keys)
		@serie.save
	else
		@serie = Serie.find(params[:serie][:id])
		@serie.update(params[:serie].symbolize_keys)
	end	
	respond_to do |format|
		if @serie.valid?			
			format.html { render :index}
			format.json { render :show, status: :created, location: @serie }
		else
			format.html { render json: @serie.errors.full_messages, status: :unprocessable_entity }
			format.json { render json: @serie.errors.full_messages, status: :unprocessable_entity }
		end
	end
  end	

  def edit
	@serie = Serie.find(params[:id])
  end

  def destroy
		@serie = Serie.find(params[:id])
		@serie.status = 'x'
		@serie.save		
		if @serie.status == 'x'
			redirect_to series_path, notice: " "
		end
	end	

  def serie_actions
	@@actions = []
	if current_user.user_type == 2
		if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#edit'))
			@@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}
		end
		if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#destroy'))
			@@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}
		end
		if @@actions = []
			act_columns_final.tap(&:pop)
		end
	else
		@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
					 {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
	end
  end	
end
