require 'rubygems'
require 'bundler'

require 'fileutils'
Bundler.setup
require 'configatron'
require 'eventmachine'

base = File.join(File.dirname(__FILE__),'jiboia')
require File.join(base,'pcap_helper')
require File.join(base,'pcap')

module Jiboia
  #config
  class << self 

    def read_config
      begin
        @yaml = YAML.load(File.read(File.join(File.dirname(__FILE__), '..','conf','paths.yaml')))
        configatron.configure_from_hash(@yaml)
      rescue Exception => ex
        puts ex.message
      end
    end
    def tshark
      configatron.tshark
    end
    def gzip
      configatron.gzip
    end
    def dumpcap
      configatron.dumpcap
    end
    def root_dir
      #add path as well to config
      configatron.root_dir = File.expand_path(File.dirname("~/adyton/traces/foo"))
    end
    
    def run(specific_file = nil)
      EM.run do
        pcap_queue = EM::Queue.new
        
        if specific_file.nil?
          Jiboia::Pcap.list_files.each { |f| pcap_queue.push f } 
        else
         pcap_queue.push specific_file if File.exists? specific_file
        end
  
        worker_queue = Proc.new do |f|
          [:tcp,:udp,:others].each do |prot|
            process_pcap = Jiboia::Pcap.new(f,prot)
            puts process_pcap.inspect
            tshark_deferrable = process_pcap.run
  
            tshark_deferrable.errback {
              puts "We couldnt process #{process_pcap.file}"
            }
            tshark_deferrable.callback {
              EM.system("#{Jiboia.gzip} #{process_pcap.output_filename}")
            }
        
            tshark_deferrable.callback {
              EM::next_tick {
                #not accurate but it helps to avoid overload the system with many childs
                next unless prot == :others
                EM.stop if pcap_queue.empty?
                pcap_queue.pop(&worker_queue)
              }
            }
          end
        end
        pcap_queue.pop(&worker_queue)
      end #EM Reactor Loop
    end
  end #class methods
end #module

#read our config from conf/paths.rb
Jiboia::read_config

