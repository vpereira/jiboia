#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__),'..','jiboia')
require 'json'
require 'goliath/api'
require 'goliath/runner'

# Example demonstrating how to use a custom Goliath runner
#

class ListFiles < Goliath::API


  
  def response(env)
    list_of_files
    [200, {}, @files.to_json]
  end
  
  private
  
  def list_of_files    
    @files = Jiboia::Pcap.list_files('20120321')
  end
end

class Bonjour < Goliath::API
  def response(env)
    [200, {}, "bonjour!"]
  end
end

class Custom < Goliath::API
  map "/files.js", ListFiles
  map "/bonjour", Bonjour
end

runner = Goliath::Runner.new(ARGV, nil)
runner.api = Custom.new
runner.app = Goliath::Rack::Builder.build(Custom, runner.api)
runner.run