require 'rubygems'
require 'bundler'

require 'fileutils'
Bundler.setup
require 'configatron'
require 'eventmachine'
require 'whenever'

base = File.join(File.dirname(__FILE__),'jiboia')
require File.join(base,'jiboia')
require File.join(base,'pcap_helper')
require File.join(base,'pcap')
require File.join(base,'dumpcap')
require File.join(base,'scheduler')
cwd = File.expand_path(File.dirname(__FILE__))

$: << cwd

module Jiboia
  extend Jiboia::ClassMethods
end

#read our config from conf/paths.rb
Jiboia::read_config

