require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "KeyValueStore" do
  before(:each) do
    @redis = mock("mock redis client")
    @redis_ns = mock("mock namespaced redis client")
    Redis.stub(:new).and_return(@redis)
    Redis::Namespace.stub(:new).with(an_instance_of(Symbol), :redis => @redis).and_return(@redis_ns)
  end
  
  describe "initialize" do
    it "should create a redis namespaced client" do
      Redis::Namespace.should_receive(:new).with(:"tahini:my_bucket", :redis => @redis).and_return(@redis_ns)
      Tahini::KeyValueStore.new(:bucket => "my_bucket")
    end
  end
  
  describe "store" do
    it "should store the key value pairs" do
      data = { "background_color" => "#eeddff", "border_color" => "#c3c3c3", "link_color" => "#000"}
      data.each do |key, value|
        @redis_ns.should_receive(:set).with(key, value).and_return("OK")
      end
      Tahini::KeyValueStore.new(:bucket => "my_bucket").store(data)
    end
  end
end