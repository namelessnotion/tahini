require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Storage" do
  
  before(:each) do
    @file_store = mock("file store instance mock")
    @key_value_store = mock("key value store instance mock")
    Tahini::FileStore.stub!(:new).and_return(@file_store)
    Tahini::KeyValueStore.stub!(:new).and_return(@key_value_store)
  end
  
  describe "initialize" do
    it "should take a bucket option" do
      storage = Tahini::Storage.new(:bucket => "my_bucket")
      storage.bucket.should == "my_bucket"
    end
    
    it "should create a key value store instance for bucket" do
      Tahini::KeyValueStore.should_receive(:new).with(:bucket => "my_bucket").and_return(@key_value_store)
      storage = Tahini::Storage.new(:bucket => "my_bucket")
    end
    
    it "should create a file store instance for bucket" do
      Tahini::FileStore.should_receive(:new).with(:bucket => "my_bucket").and_return(@file_store)
      storage = Tahini::Storage.new(:bucket => "my_bucket")
    end
  end
  
  describe "store" do
    context "data is key-value pairs" do
      it "should take and store key value pairs" do
        @key_value_store.should_receive(:store).with({ "background_color" => "#ccddff", "border_color" => "#ececec" })
        bucket = "my_bucket"
        data = { "background_color" => "#ccddff", "border_color" => "#ececec" }
        storage = Tahini::Storage.new(:bucket => bucket)
        storage.store(data)
      end
    end
    
    context "data is meta information for file" do
      it "should take and store the file meta data" do
        @file_store.should_receive(:store).with({ "background_image" => { :tempfile => "/tmp/x39dkdsjf3", :filename => "image.jpg" } })
        bucket = "my_bucket"
        data = { "background_image" => { :tempfile => "/tmp/x39dkdsjf3", :filename => "image.jpg" } }
        storage = Tahini::Storage.new(:bucket => bucket)
        storage.store(data)
      end
    end
    
    context "data is key-value pairs and file meta info" do
      it "should seperate file meta info and key value pairs and store them" do
        @file_store.should_receive(:store).with({ "background_image" => { :tempfile => "/tmp/x39dkdsjf3", :filename => "image.jpg" } })
        @key_value_store.should_receive(:store).with({ "background_color" => "#ccddff", "border_color" => "#ececec" })
        bucket = "my_bucket"
        data = {"background_color" => "#ccddff", "border_color" => "#ececec", "background_image" => { :tempfile => "/tmp/x39dkdsjf3", :filename => "image.jpg" } }
        storage = Tahini::Storage.new(:bucket => bucket)
        storage.store(data)
      end
    end
  end
  
  describe "#file_store" do
    it "should return the instance of the file store" do
      storage = Tahini::Storage.new(:bucket => "my_bucket")
      storage.file_store.should == @file_store
    end
  end
  
  describe "#key_value_store" do
    it "should return the instance of the key value store" do
      storage = Tahini::Storage.new(:bucket => "my_bucket")
      storage.key_value_store.should == @key_value_store
    end
  end
end