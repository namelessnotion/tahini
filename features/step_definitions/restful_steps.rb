When /^I post the following to '\/'$/ do |table|
  row = table.hashes.first
  
  #table.map_column!(:background_image) { |path|  File.open( File.join(File.dirname(__FILE__), '..', '..', path), 'rb')  } unless row[:background_image].nil?
  if !row["background_image"].nil?
    row["background_image"] = File.open( File.join(File.dirname(__FILE__), '..', '..', row["background_image"]), 'rb') 
  end
  @response = RestClient.post "http://127.0.0.1:3040/", "bucket" => row.delete("bucket"), "tahini_token" => row.delete("token"), "data" => row, :multipart => true
end

Then /^I should receive a success response$/ do
  JSON.parse(@response.to_str).should == {"status" => "success", "message" => "data successfully stored"}
end

Then /^the following should be stored in redis$/ do |table|
  r = Redis.new
  table.hashes.each do |row|
    r.get(row["key"]).should == row["value"]
  end
end
