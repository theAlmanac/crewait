class Hash
  def import_to_sql(model_class)
    if model_class.respond_to? :table_name
      model_class = model_class.table_name
    end
    keys = self.keys
    values = []
    keys.each do |key|
      values << (self[key].any? {|x| x != true} ? self[key] : self[key].collect {|x| 1})
    end
    values = values.transpose
    sql = values.to_sql
		
		while !sql.empty? do
			query_string = "insert into #{model_class} (#{keys.join(', ')}) values #{sql.shift}"
			while !sql.empty? && (query_string.length + sql.last.length < 999_999)  do
				query_string << ',' << sql.shift
			end
      ActiveRecord::Base.connection.execute(query_string)
		end
  end
  def <<(thing)
    new_keys = thing.keys - self.keys
    length = self.inner_length unless new_keys.empty?
    new_keys.each do |key|
      self[key] = Array.new(length || 0)
    end
    (thing.keys | self.keys).each do |key|
      self[key] << (thing[key] || nil)
    end
  end
  def inner_length
    !self.values.empty? ? self.values.first.length : nil
  end
end