#!/usr/bin/env ruby
require File.expand_path(File.join(File.join(File.dirname(__FILE__),'..','lib'),'jiboia'))

arg = ARGV[0] rescue nil
Jiboia.run(arg)
