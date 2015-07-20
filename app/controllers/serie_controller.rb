class SerieController < ApplicationController
	@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
				 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir uma série?'}}]
  def index
  	respond_to do |format|
		format.html
		format.json { render json: GeneralDatatable.new(Serie, act_columns_final, serie_actions, view_context, current_user) }
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
		if @serie.destroy
				redirect_to series_path, notice: " "
		end
	end	

  def serie_actions
  	if current_user.user_type == 2
		if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#destroy'))
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
			 			 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o série?'}}]
			elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#edit'))
			@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]
			elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('serie#destroy'))
			@@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o serie?'}}]
		
		else
			@@actions = []
			act_columns_final.tap(&:pop)
		end
	else
		@@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
			 		 {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o serie?'}}]
	end
  end	
end
