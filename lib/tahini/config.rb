module Tahini
  def self.config(&block)
    yield Config.instance
  end
  
  class Config
    attr_accessor :token, :aws_access_key_id, :aws_secret_access_key,
                  :s3_bucket, :ip, :port
    @@instance = Config.new
    def self.instance
      return @@instance
    end
  end
end