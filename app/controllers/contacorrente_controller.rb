class ContacorrenteController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index  
    @entidade = Entidade.new
    @dataInicial = ''
    @dataFinal = ''
    @entidade = Entidade.find(params[:entidade]) unless params[:entidade].blank?
    @dataInicial = params[:dataInicial] unless params[:dataInicial].blank?
    @dataFinal = params[:dataFinal] unless params[:dataInicial].blank? 
    status = "a"
    @entidades = Entidade.joins(:empresas).where("empresas.id = #{current_user.settings(:last_empresa).edited.id} and entidades.status like '#{status}'")   
  end

  def search      
    @contacorrente = Contacorrente.where(:entidade_id => params[:entidade],:data => (params[:dataInicial].to_date)..(params[:dataFinal].to_date)).order("data ASC, id ASC")    
    respond_to do |format|
      format.html { render :index }
      format.json { render json: GeneralDatatable.new(@contacorrente, act_columns_final, contacorrente_actions, view_context, current_user) }
    end               
  end  

  def new
    @contacorrente = Contacorrente.new(entidade_id: params[:entidade], adm_id: current_user.settings(:last_empresa).edited.adm_id)
    render :edit
  end

  def save
    if params[:contacorrente][:id].blank?
      @contacorrente = Contacorrente.new(params[:contacorrente].symbolize_keys)     
    else
      @contacorrente = Contacorrente.find(params[:contacorrente][:id])
      @contacorrente.data = params[:contacorrente][:data]
      @contacorrente.documento = params[:contacorrente][:documento]
      @contacorrente.descricao = params[:contacorrente][:descricao]
      @contacorrente.valor = params[:contacorrente][:valor] 
      @contacorrente.compensado = params[:contacorrente][:compensado]     
    end 
    respond_to do |format|
      if @contacorrente.save 
        @contacorrente.atualiza_conta_corrente      
        format.html { render json: @contacorrente.entidade_id }
        format.json { render :show, status: :created, location: @contacorrente }
      else
        format.html { render json: @contacorrente.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @contacorrente.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def atualizarTotais  
    @contacorrente = Contacorrente.where("entidade_id = #{params[:entidade]}").order("data DESC, id DESC").first
    unless @contacorrente.blank?
      @ultimoSaldo = number_to_currency(@contacorrente.saldo.to_f, separator: ",", delimiter: ".",format: '%n')
      @ultimoSaldoData = @contacorrente.data.to_date.strftime("%d/%m/%Y")
      @resultado = Contacorrente.where(:data =>(params[:dataInicial].to_date)..(params[:dataFinal].to_date)).sum :valor   
      @saldoPeriodo = number_to_currency(@resultado.to_f, separator: ",", delimiter: ".",format: '%n')     
      @resultado = Contacorrente.where("compensado = 'Compensado'").sum :saldo
      @saldoCompensado = number_to_currency(@resultado.to_f, separator: ",", delimiter: ".",format: '%n')
    end
    @data = {:ultimoSaldo => @ultimoSaldo, :ultimoSaldoData => @ultimoSaldoData, :saldoPeriodo => @saldoPeriodo, :saldoCompensado => @saldoCompensado}
    render json: @data
  end  

  def edit
    @contacorrente = Contacorrente.find(params[:id])    
  end

  def destroy
    @contacorrente = Contacorrente.find(params[:id])
    if @contacorrente.destroy
      @contacorrente.atualiza_conta_corrente 
      redirect_to contacorrentes_path, notice: " "
    end  
  end
  def contacorrente_actions
    if current_user.user_type == 2
      if current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('contacorrente#edit')) && current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('contacorrente#destroy'))
        @@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
               {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o documento?'}}]
      elsif  current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('contacorrente#edit'))
        @@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'}]
      elsif current_user.nivelacesso.acessos.include?(Acesso.find_by_acao('contacorrente#destroy'))
        @@actions = [{:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o documento?'}}]
      
      else
        @@actions = []
        act_columns_final.tap(&:pop)
      end
    else
      @@actions = [{:caption => 'Editar', :method_name => :get, :class_name => 'btn yellow btn-xs pull-center', :action => 'edit'},
             {:caption => 'Deletar', :method_name => :delete, :class_name => 'btn red-thunderbird btn-xs ', :action => 'destroy', :data => {confirm: 'Tem certeza que deseja excluir o documento?'}}]
    end
  end
end
