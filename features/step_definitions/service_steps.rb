When /^I start Tahini$/ do

end

Then /^Tahini should be running on "([^"]*)" port "([^"]*)"$/ do |ip, port|
  response = RestClient.get "http://#{ip}:#{port}/"
  response.code.should == 200
  response.to_str.should == "tahini is tasty!"
end
