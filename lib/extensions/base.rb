class ActiveRecord::Base
  def self.next_insert_id
    database = YAML.load(open(File.join('config', 'database.yml')))[RAILS_ENV]['database']
    ActiveRecord::Base.connection.execute( "
      SELECT auto_increment
      FROM information_schema.tables
      WHERE table_name='#{self.table_name}' AND
            table_schema ='#{database}'
    " ).fetch_hash['auto_increment'].to_i
  end

  def self.crewait(hash)
		stay_a_hash = hash.delete(:stay_a_hash)
		unless stay_a_hash
			Crewait.for(self, hash)
		else
			object = self.new(hash)
			object.before_validation
	  	Crewait.for(object.class, object.attributes)
		end
	end
end