require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Tahini' do
  describe "/" do
    describe "get" do
      it "should get home page" do
        get '/'
        
        last_response.should be_ok
        last_response.body.should include('tahini is tasty!')
      end
    end
    
    describe "post" do
      
      before(:each) do
        @storage = mock("Mock of Storage instance")
        @storage.stub(:store).and_return(true)
        Tahini::Storage.stub(:new).and_return(@storage)
      end
      
      describe "authenticate" do
        it "should authenticated client" do
          post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
          last_response.should be_ok
        end
        
        it "should deny un-authenticated clients" do
          post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'bad', 'bucket' => 'my_bucket'   
          last_response.status.should == 401
        end
      end
      
      # key values pairs and image files will be posted to /
      describe "handling key value pairs" do
        it "should create a storage instance for the bucket" do
          Tahini::Storage.should_receive(:new).with(:bucket => "my_bucket")
          post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
        end
        
        it "should store posted data" do
          @storage.should_receive(:store).with({'these' => 'params'})
          post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
        end
        
        context "valid data is posted" do
          before(:each) do
            @storage.stub(:store).and_return(true)
          end
          
          it "should have http success status" do
            post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
            last_response.should be_ok
          end
          
          it "should return a success message" do
            post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
            JSON.parse(last_response.body).should =={'status' => 'success', 'message' => 'data successfully stored'}
          end
        end
        
        context "invalid data is posted" do
          before(:each) do
            @storage.stub(:store).and_return(false)
            @storage.stub(:errors).and_return("{'errors': 'error messages'}")
            Tahini::Storage.stub(:new).and_return(@storage)
          end
          
          it "should have http success status" do
            post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
            last_response.should be_ok
          end
          
          it "should have failure status" do
            post '/', 'data' => {'these' => 'params'}, 'tahini_token' => 'q1w2e3r4', 'bucket' => 'my_bucket'
            last_response.body.should == "{'errors': 'error messages'}"
          end
        end
      end
    end
  end
  
  describe "/:bucket/:filename.css" do
    
  end
  
end
