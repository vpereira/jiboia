#!/usr/bin/env ruby
require File.expand_path(File.join(File.join(File.dirname(__FILE__),'..','lib'),'jiboia'))
require File.expand_path(File.join(File.join(File.dirname(__FILE__),'..','lib','cli'),'jiboia_command'))
#arg = ARGV[0] rescue nil
#Jiboia.run(arg)
#
JiboiaCommand.start
