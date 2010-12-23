Feature: Posting
  In order to store data
  As a dev
  I want to be able to have my application post data to tahini to store

  Scenario: Posting just key value pairs
	When I post the following to '/'
	  | token                                    | bucket    | background_color | border_color | link_color | font_color | sidebar_background_color |
	  | aa41d57ea0d92286449d276aba3ef470a21ec4a1 | my_bucket | #cc33cc          | #ddd         | #000       | #d3d3d3    | #abc                     |
	Then I should receive a success response
	And the following should be stored in redis
	 | tahini:my_bucket:background_color         | #cc33cc |
	 | tahini:my_bucket:border_color             | #ddd    |
	 | tahini:my_bucket:link_color               | #000    |
	 | tahini:my_bucket:font_color               | #d3d3d3 |
	 | tahini:my_bucket:sidebar_background_color | #abc    |
	
  Scenario: Posting just key value pairs
	When I post the following to '/'
	  | token                                    | bucket    | background_color | border_color | link_color | font_color | sidebar_background_color | background_image              |
	  | aa41d57ea0d92286449d276aba3ef470a21ec4a1 | my_bucket | #cc33cc          | #ddd         | #000       | #d3d3d3    | #abc                     | spec/fixtures/files/image.jpg |
	Then I should receive a success response
	And the following should be stored in redis
	 | key                                       | value                                                                  |
	 | tahini:my_bucket:background_color         | #cc33cc                                                                |
	 | tahini:my_bucket:border_color             | #ddd                                                                   |
	 | tahini:my_bucket:link_color               | #000                                                                   |
	 | tahini:my_bucket:font_color               | #d3d3d3                                                                |
	 | tahini:my_bucket:sidebar_background_color | #abc                                                                   |
	 | tahini:my_bucket:background_image         | http://s3.amazonaws.com/tahini-cucumber/my_bucket/background_image.jpg |

  
