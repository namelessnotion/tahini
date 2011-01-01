module Tahini
  class KeyValueStore
    def initialize(options = {})
      @redis = Redis.new
      @redis_ns = Redis::Namespace.new(:"tahini:#{options[:bucket]}", :redis => @redis)
    end
    
    def store(data)
      data.each do |key, value|
        @redis_ns.set key, value
      end
    end
    
    def get
      keys = @redis_ns.keys( "*" )
      if keys.length > 0
        values = @redis_ns.mget(*keys)
        Hash[*keys.zip(values).flatten]
      else
        {}
      end
    end
    
    def delete
      keys = @redis_ns.keys("*")
      if keys.length == 0
        true
      else
        @redis_ns.del(*keys) == keys.length
      end
    end
    
    def delete(key)
      @redis_ns.del(key)
    end
  end
end