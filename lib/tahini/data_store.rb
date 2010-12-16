module PersonalizedCss
  class DataStore
    def self.redis
      @redis ||= Redis.new
    end
  end
end
