class PlanocontaController < ApplicationController
    @@actions = []

  def index
    respond_to do |format|
      format.html
      format.json { render json: GeneralDatatable.new(Planoconta.where("status != 'x'"), act_columns_final, planoconta_actions, view_context, current_user) }
    end
  end

  def new 
    @pai = Planoconta.new  
    if params[:id].blank?      
      @aux = Planoconta.where("codigo like '%_' and empresa_id = #{current_user.settings(:last_empresa).edited.id}").order("codigo DESC").first   
      if @aux.blank?
        @codigo = 1
      else
        @codigo = @aux.codigo.to_i + 1
      end  
      @planoconta = Planoconta.new(codigo: @codigo,descricao: '', 
      adm_id: current_user.settings(:last_empresa).edited.adm_id, empresa_id: current_user.settings(:last_empresa).edited.id)
      @nivel1 = true 
    else      
      @codigo_pai =  Planoconta.find(params[:id]).codigo        
      @split = @codigo_pai.split('.')
      @count = 0
      @decimal = '_'      
      while @count < (@split.length-1) 
        @decimal = @decimal + '_'
        @count += 1
      end      
      @aux = Planoconta.where("codigo like '#{@codigo_pai + '.' + @decimal + '_'}' and empresa_id = #{current_user.settings(:last_empresa).edited.id}").order("codigo DESC").first
      if @aux.blank?
        @codigo = @codigo_pai + '.' + @decimal.gsub('_','0') + '1'
      else        
        @split = @aux.codigo.split('.')        
        @tam = @split[@split.length-1].to_i + 1                             
        @codigo = @aux.codigo.to_s[0..-(@tam.to_s.length+1)]            
        @codigo = @codigo.to_s + @tam.to_s    
      end     
      @planoconta = Planoconta.new(codigo: @codigo,descricao: '', planoconta_id: params[:id], 
      adm_id: current_user.settings(:last_empresa).edited.adm_id, empresa_id: current_user.settings(:last_empresa).edited.id)
      @pai = Planoconta.find(params[:id])
      @nivel1 = false
    end  
    render :edit
  end

  def save           
      if params[:planoconta][:id].blank?
        @planoconta = Planoconta.new(params[:planoconta].symbolize_keys)     
      else       
        @planoconta = Planoconta.find(params[:planoconta][:id])   
        @planoconta.descricao = params[:planoconta][:descricao]                 
      end 
      respond_to do |format|
        if @planoconta.save      
          format.html { render :index}
          format.json { render :show, status: :created, location: @planoconta }
        else
          format.html { render json: @planoconta.errors.full_messages, status: :unprocessable_entity }
          format.json { render json: @planoconta.errors.full_messages, status: :unprocessable_entity }
        end
      end
  end

  def edit
    @planoconta = Planoconta.find(params[:id])
    @pai = Planoconta.new
    @split = @planoconta.codigo.split('.') 
    if @split.length == 1
      @nivel1 = true
    else
      @nivel1 = false
    end 
    @pai = Planoconta.find(@planoconta.planoconta_id) unless @planoconta.planoconta_id.blank?
  end

  def destroy
    @planoconta = Planoconta.find(params[:id])
    @planoconta.status = 'x'
    @planoconta.save
    if @planoconta.status == 'x'      
      redirect_to planocontas_path, notice:""
    end  
  end

  def planoconta_actions
    @@actions = []
    if current_user.user_type == 2
      if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('planoconta#new')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('planoconta#destroy')) || current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('planoconta#statusset'))
        @@actions << {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}
        #@@actions << {:caption => 'Incluir', :method_name => :get, :class_name => 'btn blue btn-xs ', :action => 'new'}
      end
      if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('planoconta#edit'))
        @@actions << {:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'}
      end
     if  @@actions = []
        act_columns_final.tap(&:pop)
      end
    else
      @@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs ', :action => 'edit'},
        {:caption => '<i class="fa fa-gear"></i>'.html_safe, :class_name => 'btn green-haze dropdown-toggle btn-xs', :state => 'Status'}]
    end
  end  

end
