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
		data.each_with_index do |item, index|
			item.each_with_index do |subitem, subindex|
				if @klass.name == "Subgrupo"
					if subitem.is_a?(Integer)
						subData2[subindex] = Grupo.find_by(id: subitem).descricao
					else
						subData2 = item
					end
				else
					subData2 = item
				end
			end
			data2[index] = subData2
		end
		{
			sEcho: params[:sEcho].to_i,
			iTotalRecords: filtered_list.count,
			iTotalDisplayRecords: records.total_entries,
			aaColumns: columnsDef,
			aaData: data2
		}
	end

	private

	def data
		final_array = Array.new
		records.map do |record|
			data_array = Array.new
			links_array = Array.new
			#usuario master ou adm
			if @current_user.user_type == 0 || @current_user.user_type == 1
				if record.try(:adm_id)
					if record.adm_id == @current_user.settings(:last_empresa).edited.adm_id
						if record.is_a?(Entidade) || record.is_a?(Grupo) || record.is_a?(Subgrupo) || record.is_a?(Produto)
							if record.empresas.include?(current_user.settings(:last_empresa).edited)
								columns.each_with_index do |item, index|					
									data_array[index] = record.send(item)
								end
								actions.each_with_index do |item, index|
									item[:id] = record.id
									links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=> item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
								end
								final_array << (data_array << links_array.join(""))
							else
								record = nil
							end 
						else
							columns.each_with_index do |item, index|					
								data_array[index] = record.send(item)
							end
							actions.each_with_index do |item, index|
								item[:id] = record.id
								links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=> item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
							end
							final_array << (data_array << links_array.join(""))
						end
					else
						record = nil
					end
				else
					columns.each_with_index do |item, index|					
						data_array[index] = record.send(item)
					end
					actions.each_with_index do |item, index|
						item[:id] = record.id
						links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=> item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
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
						actions.each_with_index do |item, index|
							item[:id] = record.id
							links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id => item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
						end
						final_array << (data_array << links_array.join(""))
				
					#se o dado for usuario e for comum, envia!
					elsif record.is_a?(User) && @current_user.settings(:last_empresa).edited.users.include?(record) && record.user_type == 2
						columns.each_with_index do |item, index|					
							data_array[index] = record.send(item)
						end
						actions.each_with_index do |item, index|
							item[:id] = record.id
							links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=>item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
						end
						final_array << (data_array << links_array.join(""))
					
					#...se for entidade, grupo ou subgrupo é filtrado pela empresa atual, senão só vai..
					else
						if record.adm_id == @current_user.settings(:last_empresa).edited.adm_id
							if record.is_a?(Entidade) || record.is_a?(Grupo) || record.is_a?(Subgrupo) || record.is_a?(Produto)

								if record.empresas.include?(current_user.settings(:last_empresa).edited)
									columns.each_with_index do |item, index|					
										data_array[index] = record.send(item)
									end
									actions.each_with_index do |item, index|
										item[:id] = record.id
										links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=> item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
									end
									final_array << (data_array << links_array.join(""))
								else
									record = nil
								end 
							else
								columns.each_with_index do |item, index|					
									data_array[index] = record.send(item)
								end
								actions.each_with_index do |item, index|
									item[:id] = record.id
									links_array[index] = link_to(item.values[0], item.except(:caption, :class_name),:method => item.values[1],:id=> item.values[0] + record.id.to_s, :class => item.values[2], :data => item.values[4])
								end
								final_array << (data_array << links_array.join(""))
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
			@klass = @klass.where(:adm_id => current_user.adm_id) 
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
		s_string = " ILIKE :search"
		search_array = Array.new
		columns.each_with_index do |item, index|
			search_array[index] = item
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