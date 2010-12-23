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
  end
end