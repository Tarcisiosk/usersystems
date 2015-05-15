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
end
