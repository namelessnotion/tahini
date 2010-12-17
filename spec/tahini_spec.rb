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
      describe "authenticate" do
        it "should authenticated client" do
          post '/', 'these' => 'params', 'tahini_token' => 'q1w2e3r4'
          last_response.should be_ok
        end
        
        it "should deny un-authenticated clients" do
          post '/', 'these' => 'params', 'tahini_token' => 'bad'          
          last_response.status.should == 401
        end
      end
      
      # key values pairs and image files will be posted to /
      describe "handling key value pairs" do
        it "should store posted data"
        context "valid data is posted" do
          it "should have success status"
          it "should return the key value pairs just stored"
        end
        
        context "invalid data is posted" do
          it "should have failure status"
          it "should return the invalidation response from the Store"
        end
      end
    end
  end
  
  describe "/:bucket/:filename.css" do
    
  end
  
end
