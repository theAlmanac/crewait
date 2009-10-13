class Array
  def to_sql
  	self.collect {|x| "(#{x.collect{|x| x.nil? ? 'NULL' : "#{ActiveRecord::Base.sanitize(x)}"}.join(', ')})" }
  end
end