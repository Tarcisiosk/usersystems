class GeneralDatatable < ApplicationController
 delegate :params, :h, :link_to, :number_to_currency, to: :@view
 
	#Klass - Classe do objeto 
	#Column_sort - Colunas 

	def initialize(klass, column_data, actions_array, view, current_user)
		@klass = klass
		@column_data = column_data
		@actions_array = actions_array
		@view = view
		@current_user = current_user
	end

	def as_json(options = {})
		data2 = Array.new
		subData2 = Array.new
		activeData = Array.new
		inactiveData = Array.new
		deletedData = Array.new

		data.each_with_index do |item, index|
			item.each_with_index do |subitem, subindex|				
				if @klass.name == "Subgrupo"
					if subitem.is_a?(Integer)
						subData2[subindex] = Grupo.find_by(id: subitem).descricao
					else
						subData2 = item
					end
				elsif @klass.name == "Movimentom"
					if subitem.is_a?(Integer)
						subData2[subindex] = Entidade.find_by(id: subitem).nome_fantasia
					else
						subData2 = item
					end
				elsif @klass.name == "Contacorrente" || @klass.name == "Movimentom"
					if subitem.is_a?(Float)
						if subitem.to_s.include? "-"
							subData2[subindex] = '<font color="red" style="float: right">'+number_to_currency(subitem, separator: ",", delimiter: ".", format: "%n")+'</font>'
						else
							subData2[subindex] = '<font color="blue" style="float: right">'+number_to_currency(subitem, separator: ",", delimiter: ".", format: "%n")+'</font>'
						end	
					else
						subData2 = item
					end
					if subitem.is_a?(String)
						if subitem == "Compensado"
							subData2[subindex] = '<span class="label label-sm label-success">'+subitem
						end
						if subitem == "Não Compensado"
							subData2[subindex] = '<span class="label label-sm label-danger">'+subitem
						end	
					else
						subData2 = item
					end	
				else
					subData2 = item						
					if !!subitem == subitem && subitem == true 
						subData2[subindex] = '<span class="glyphicon glyphicon-ok font-green"/>'
					elsif !!subitem == subitem  && subitem == false 
						subData2[subindex] = '<span class="glyphicon glyphicon-remove font-red"/>'
					end
				end
				if subitem.is_a?(Date)
					puts "#{subitem}"
					subData2[subindex] = subitem.strftime("%d/%m/%Y")
				end	
			end
			data2[index] = subData2
		end
		
		data2.each_with_index do |item, index|
		 	if item.last.include?('Inativo')
		 		inactiveData << item
		 	else
		 		#puts "++++++++++++++++++++++++++++++ ITEM = #{item}"
		  		activeData << item
		 	end
		end

		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: filtered_list.count,
			iTotalDisplayRecords: records.total_entries,
			aaColumns: columnsDef,
			aData: activeData,
			iData: inactiveData
		}
	end

	private

	def data
		final_array = Array.new
		records.map do |record|
			data_array = Array.new
			links_array = Array.new
			#usuario logado é master ou adm			
			if @current_user.user_type == 0 || @current_user.user_type == 1
				if record.try(:adm_id) != nil
					if record.adm_id == @current_user.settings(:last_empresa).edited.adm_id
						if record.try(:empresas) == nil && record.try(:empresa) == nil
							columns.each_with_index do |item, index|					
								data_array[index] = record.send(item)
							end
							actions.each_with_index do |item, index|
								if item[:state].to_s == 'Status'
									if record.status == 'a'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									elsif record.status == 'i'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									end
								else
									item[:id] = record.id
									links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption] + record.id.to_s, :class => item[:class_name], :data => item[:data])
								end
							end
							final_array << (data_array << links_array.join(""))
						else 
							empresas = []
							empresas = record.empresas if record.try(:empresas) != nil
							empresas << record.empresa if record.try(:empresa) != nil
							if empresas.include?(current_user.settings(:last_empresa).edited)
								columns.each_with_index do |item, index|					
									data_array[index] = record.send(item)
								end
								actions.each_with_index do |item, index|									
									if item[:state].to_s == 'Status'
										if record.status == 'a'
											links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
										elsif record.status == 'i'
											links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
										end
									else
										item[:id] = record.id
										links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
									end
								end
								final_array << (data_array << links_array.join(""))
							else
								record = nil
							end 
						end
					else
						record = nil
					end
				else
					columns.each_with_index do |item, index|					
						data_array[index] = record.send(item)
					end
					actions.each_with_index do |item, index|
						if item[:state].to_s == 'Status'
							if record.status == 'a'
								links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
							elsif record.status == 'i'
								links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
							end
						else
							item[:id] = record.id
							links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
						end
					end
					final_array << (data_array << links_array.join(""))
				end

			#usuario comum
			else
				if record.adm_id == @current_user.adm_id || record.adm_id == @current_user.id

					#se o dado for uma empresa verifica se o usuario tem acesso a ela
					if record.is_a?(Empresa) && @current_user.empresas.include?(record) 
						columns.each_with_index do |item, index|					
							data_array[index] = record.send(item)
						end
						if actions
							actions.each_with_index do |item, index|
								if item[:state].to_s == 'Status'
									if record.status == 'a'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									elsif record.status == 'i'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									end
								else
									item[:id] = record.id
									links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
								end
							end
						end
						final_array << (data_array << links_array.join(""))
				
					#se o dado for usuario e for comum, envia!
					elsif record.is_a?(User) && @current_user.settings(:last_empresa).edited.users.include?(record) && record.user_type == 2
						columns.each_with_index do |item, index|					
							data_array[index] = record.send(item)
						end
						if actions
							actions.each_with_index do |item, index|
								if item[:state].to_s == 'Status'
									if record.status == 'a'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									elsif record.status == 'i'
										links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
									end
								else
									item[:id] = record.id
									links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
								end
							end
						end
						final_array << (data_array << links_array.join(""))
					
					#...se for entidade, grupo ou subgrupo é filtrado pela empresa atual, senão só vai..
					else
						if record.adm_id == @current_user.settings(:last_empresa).edited.adm_id
							if record.try(:empresas) == nil && record.try(:empresa) == nil
								columns.each_with_index do |item, index|					
									data_array[index] = record.send(item)
								end
								if actions

									actions.each_with_index do |item, index|
										if item[:state].to_s == 'Status'
											if record.status == 'a'
												links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
											elsif record.status == 'i'
												links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
											end
										else
											item[:id] = record.id
											links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
										end
									end
								end
								final_array << (data_array << links_array.join(""))
							else
								empresas = []
								empresas = record.empresas if record.try(:empresas) != nil
								empresas << record.empresa if record.try(:empresa) != nil
								if empresas.include?(current_user.settings(:last_empresa).edited)
									columns.each_with_index do |item, index|					
										data_array[index] = record.send(item)
									end
									if actions
										actions.each_with_index do |item, index|
											if item[:state].to_s == 'Status'
												if record.status == 'a'
													links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s , :class => item[:class_name], :state => 'Ativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
												elsif record.status == 'i'
													links_array[index] = link_to(item[:caption], "", :id => 'Opt' + record.id.to_s, :class => item[:class_name], :state => 'Inativo', :data => {:toggle=>'dropdown', 'close-others'=> 'true'})
												end
											else
												item[:id] = record.id
												links_array[index] = link_to(item[:caption], item.except(:caption, :class_name), :method => item[:method_name], :id => item[:caption]+record.id.to_s, :class => item[:class_name], :data => item[:data])
											end
										end
									end
									final_array << (data_array << links_array.join(""))
								else
									record = nil
								end 
							end
						end	
					end
				else	
					record = nil
				end
			end
		end
		final_array
	end

	def records
		@records ||= fetch_records
	end

	def fetch_records
		records = filtered_list
		records = selected_columns(records)
		records = records.order("#{sort_column} #{sort_direction}")
		records = records.page(page).per_page(per_page)
		if params[:sSearch].present?
			records = records.where(search_columns, search: "%#{params[:sSearch]}%")
		end
		records
	end
 
	def filtered_list
		if current_user.user_type != 0
			@klass = @klass.where(:adm_id => current_user.settings(:last_empresa).edited.adm_id) 
		else
			@klass.all
		end
	end

	def selected_columns records
		records
	end

	def page
		params[:iDisplayStart].to_i/per_page + 1
	end

	def per_page
		params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
	end

	def columns
		data_columns = Array.new
		@column_data.each_with_index do |item, index|
			if item.has_key?("data_name".to_sym)
				data_columns[index] = item.slice(:data_name).values[0]
			end
		end
		data_columns
	end
	
	def columnsDef
		def_columns = []
		@column_data.each_with_index do |item, index|
			def_columns[index] = item.except(:data_name, :bDefault)
		end
		def_columns
	end

	def actions
		@actions_array

	end
	
	def search_columns
		search_string = ""
		s_string = " ILIKE :search"
		search_array = Array.new
		columns.each_with_index do |item, index|					
			if @klass.columns_hash[item.to_s].type.to_s.eql?"date"										
				search_array[index] = "to_char("+item+",'dd/MM/yyyy')"
			elsif @klass.columns_hash[item.to_s].type.to_s.eql?"float" or @klass.columns_hash[item.to_s].type.to_s.eql?"integer" 							
				search_array[index] = "to_char("+item+",'9999999D99')"			
			else
				search_array[index] = item	
			end							
		end			
		return search_array.join(" ILIKE :search or ") + s_string
	end

	def sort_column
		columns[params[:iSortCol_0].to_i]
	end

	def sort_direction
		params[:sSortDir_0] == "desc" ? "desc" : "asc"
	end

end