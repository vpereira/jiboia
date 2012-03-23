#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__),'..','jiboia')
require 'json'
require 'goliath/api'
require 'goliath/runner'
require 'active_support'
require 'active_support/hash_with_indifferent_access'

# Example demonstrating how to use a custom Goliath runner
#

class ListFiles < Goliath::API
  
  def response(env)
    env =  ActiveSupport::HashWithIndifferentAccess.new(env)
    list_of_files(env[:params][:date])
    [200, {}, @files.to_json]
  end
  
  private
  #TODO
  #DEFAULT VALUE SHOULD BE TODAY FORMATED
  def list_of_files(timestamp = Pcap::timestamp_to_directory)   
    @files = { timestamp => Jiboia::Pcap.list_files(timestamp).collect { |f| File.basename(f,'.cap.gz')} } 
  end
end

class DownloadFile < Goliath::API
  def response(env)
    [200, {}, "bonjour!"]
  end
  

end

class Custom < Goliath::API
  map "/:date/files.js", ListFiles
  map "/:date/:file.js", DownloadFile
end

runner = Goliath::Runner.new(ARGV, nil)
runner.api = Custom.new
runner.app = Goliath::Rack::Builder.build(Custom, runner.api)
runner.run