module Tahini
  class FileStore #< AWS::S3::S3Object #in the future
    def initialize(options = {})
      @s3 = AWS::S3::Base.establish_connection!(
        :access_key_id => Config.instance.aws_access_key_id,
        :secret_access_key => Config.instance.aws_secret_access_key)
      @s3_bucket = AWS::S3::Bucket.find(Config.instance.s3_bucket)
      @bucket = options[:bucket]
    end
    
    def store(data)
      key_values = {}
      data.each do |key, value|
        extension = File.extname(value[:filename])
        file = "#{@bucket}/#{key}#{extension}"
        s3_object = AWS::S3::S3Object.store(file, value[:tempfile], @s3_bucket.name, :access => :public_read)
        key_values[key] = "http://s3.amazonaws.com/#{@s3_bucket.name}/#{file}"
      end
      Storage.new(:bucket => @bucket).store(key_values) unless key_values.empty?
    end
  end
end
