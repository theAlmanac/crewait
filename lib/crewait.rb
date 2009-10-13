$: << File.join(File.dirname(__FILE__), '/../lib')

require 'rubygems'
require 'activerecord'
require 'extensions/array'
require 'extensions/base'
require 'extensions/hash'

# Crewait is a tool for ActiveRecord for mass-importing of data.
# The idea is the you start a Crewait session, you use ActiveRecord::Base#crewait instead of #create, and then at some point you tell it to go!, which bulk inserts all those created records into SQL.
class Crewait
  VERSION = '1.0.0'
  
  def self.start_waiting
    # clear our all important hash caches
    @@hash_of_hashes = {}
    @@hash_of_next_inserts = {}
  end
  
  # add one crewait instance
  def self.for(model, hash)
    table_name = model.table_name
    # if this class is new, add in the next_insert_value
    @@hash_of_next_inserts[table_name] ||= model.next_insert_id
    # if this class is new, create a new hash to receive it
    if !@@hash_of_hashes[table_name]
      @@hash_of_hashes[table_name] = {}
      hash.keys.each do |key|
        @@hash_of_hashes[table_name][key] = []
      end
    end
    @@hash_of_hashes[table_name].respectively_insert(hash)
    fake_id = @@hash_of_next_inserts[table_name] + @@hash_of_hashes[table_name].inner_length - 1
    eigenclass = class << hash; self; end
    eigenclass.class_eval {
      define_method(:id) { fake_id }
      hash.each do |key, value|
        define_method(key) { value }
      end
    }
    hash
  end
  
  def self.go!
    @@hash_of_hashes.each do |key, hash|
      hash.import_to_sql(eval(key.classify))
    end
    @@hash_of_hashes = {}
    @@hash_of_next_inserts = {}
  end
end