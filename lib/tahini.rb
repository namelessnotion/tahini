require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/setup'
#Bundler.require(:default)
Bundler.setup
require 'redis'
require 'aws/s3'
RMAGICK_BYPASS_VERSION_TEST = true
require 'RMagick'

require 'sinatra'
#require 'sinatra_warden'
require 'warden'

require 'redis'
require 'redis-namespace'
require 'aws/s3'

require 'lib/sinatra/warden/helper'

#require File.join(File.dirname(__FILE__),'tahini', 'config')

require File.join(File.dirname(__FILE__),'tahini', 'storage')
require File.join(File.dirname(__FILE__),'tahini', 'server')


