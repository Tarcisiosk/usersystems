class AbstractRecord <  ActiveRecord::Base

	self.abstract_class = true
	def self.total(cols)
		total_columns = []
		cols.each_with_index do |item, index|
			total_columns[index] = item
		end
		total_columns
	end

	def self.returnDefaults(cols)
		default_columns = []
		cols.each_with_index do |item, index|
			if item[:bDefault] == true 
				default_columns[index] = item
			end
		end
		default_columns
	end

	def version_id_sequence
		array_version_sequence = ActiveRecord::Base.connection.execute("SELECT nextval('version_id_seq') AS version_id")
		version_object = array_version_sequence[0]		 
		return version_object["version_id"]
	end	

	def self.attr_localized(*fields)
    fields.each do |field|
      define_method("#{field}=") do |value|      	
        self[field] = value.is_a?(String) ? value.to_s.scan(/\b-?[\d.]+/).join.to_f : value    	
      end
    end
  end

end
