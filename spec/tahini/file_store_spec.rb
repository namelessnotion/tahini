require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FileStore" do
  
  before(:each) do
    @s3 = mock("mock aws s3 connection")
    @s3_bucket = mock("mock aws s3 bucket", :name => "tahini_s3_bucket")
    AWS::S3::Base.stub(:establish_connection!).with(:access_key_id => 'abc', :secret_access_key => '123').and_return(@s3)
    AWS::S3::Bucket.stub(:find).with("tahini_s3_bucket").and_return(@s3_bucket)
  end
  
  describe "initialize" do
    it "should setup AWS S3" do
      AWS::S3::Base.should_receive(:establish_connection!).with(:access_key_id => 'abc', :secret_access_key => '123').and_return(@s3)
      Tahini::FileStore.new(:bucket => "my_bucket")
    end
    
    it "should set the s3 bucket" do
      AWS::S3::Bucket.should_receive(:find).with("tahini_s3_bucket").and_return(@s3_bucket)
      Tahini::FileStore.new(:bucket => "my_bucket")
    end
  end
  
  describe "store" do
    it "should upload each file to amazon s3" do
      data = { "background_image" => { :tempfile => fixture_file("image.jpg"), :filename => "image.jpg" }, "logo" => { :tempfile => fixture_file("image.png"), :filename => "image.png" } }
      AWS::S3::S3Object.should_receive(:store).with('my_bucket/logo.png', an_instance_of(File), "tahini_s3_bucket", :access => :public_read  ).and_return(mock("s3_object logo", :url => "http://s3.amazonaws.com/tahini/my_bucket/logo.png"))
      AWS::S3::S3Object.should_receive(:store).with('my_bucket/background_image.jpg', an_instance_of(File), "tahini_s3_bucket", :access => :public_read  ).and_return(mock("s3_object background", :url => "http://s3.amazonaws.com/tahini/my_bucket/background_image.jpg"))
      Tahini::FileStore.new(:bucket => "my_bucket").store(data)
    end
    
    it "should store the key value pairs of the upload files" do
      data = { "background_image" => { :tempfile => fixture_file("image.jpg"), :filename => "image.jpg" }, "logo" => { :tempfile => fixture_file("image.png"), :filename => "image.png" } }
      AWS::S3::S3Object.stub(:store).with('my_bucket/logo.png', an_instance_of(File), "tahini_s3_bucket", :access => :public_read ).and_return(mock("s3_object logo", :url => "http://s3.amazonaws.com/tahini/my_bucket/logo.png"))
      AWS::S3::S3Object.stub(:store).with('my_bucket/background_image.jpg', an_instance_of(File), "tahini_s3_bucket", :access => :public_read ).and_return(mock("s3_object background", :url => "http://s3.amazonaws.com/tahini/my_bucket/background_image.jpg"))
      
      @storage = mock("Mock storage instance")
      @storage.should_receive(:store).with( { "logo" => "http://s3.amazonaws.com/tahini_s3_bucket/my_bucket/logo.png", "background_image" => "http://s3.amazonaws.com/tahini_s3_bucket/my_bucket/background_image.jpg"} )
      Tahini::Storage.should_receive(:new).with(:bucket => "my_bucket").and_return(@storage)
      Tahini::FileStore.new(:bucket => "my_bucket").store(data)   
    end
  end
end