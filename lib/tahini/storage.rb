require 'lib/tahini/file_store'
require 'lib/tahini/key_value_store'

module Tahini
  class Storage
    
    attr_reader :key_value_store, :file_store, :bucket
    
    def initialize(options = {})
      @bucket = options[:bucket]
      @key_value_store = KeyValueStore.new(:bucket => @bucket)
      @file_store = FileStore.new(:bucket => @bucket)
    end
    
    def store(data)
      key_values = data.reject &if_not_a_key_value_pair
      files = data.reject &if_not_a_file
      @key_value_store.store(key_values) unless key_values.empty?
      @file_store.store(files) unless files.empty?
      true
    end
    
    def if_not_a_key_value_pair
      Proc.new { |key, value| !value.is_a?(String) && !value.is_a?(Numeric)}
    end
    
    def if_not_a_file
      Proc.new { |key, value| !value.is_a?(Hash) || value[:tempfile].nil? || value[:filename].nil? }
    end
  end
end
