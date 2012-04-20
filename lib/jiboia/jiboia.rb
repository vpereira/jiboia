module Jiboia
  module ClassMethods
    def read_config
      begin
        @yaml = YAML.load(File.read(File.join(File.dirname(__FILE__), '..','..','config','paths.yaml')))
        configatron.configure_from_hash(@yaml)
      rescue Exception => ex
        puts ex.message
      end
    end
    def debug
      true
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
      configatron.root_dir = File.expand_path(File.join(File.dirname(__FILE__),'..','..','traces'))
    end
    def pre_defined_ports
      {
        :tcp=>[21,22,25,80,110,443,3306],
        :udp=>[53,389,69,123],
        :others=>[0]
      }
    end

    def split_protocols(f,&block)
      pre_defined_ports.each do |prot,ports|
        ports.each do |pp|
          block.call Jiboia::Pcap.new(f,prot,pp) if block_given?
        end
      end
    end
    def run(options = {})
      EM.run do
        keep_file = options[:keep_files]
        specific_file = File.expand_path(options[:with_file]) || nil
        #TODO implement directory
        pcap_queue = EM::Queue.new

        if specific_file.nil?
          Jiboia::Pcap.list_files.each { |f| pcap_queue.push f } 
        else
         pcap_queue.push specific_file if File.exists? specific_file
        end
        #Im running EM::Queue because it is a safeway to share a variable among deferrables
        running_deferrables = EM::Queue.new


        worker_queue = Proc.new do |f|
          split_protocols(f) do |process_pcap|
              tshark_deferrable = process_pcap.run
              tshark_deferrable.errback {
                puts "We couldnt process #{process_pcap.file}"
              }

              tshark_deferrable.callback {
                running_deferrables.pop {} unless running_deferrables.empty?
                EM.system("#{Jiboia.gzip} #{process_pcap.output_filename}") if options[:zip_files_after] == true
              }

              unless keep_file
                tshark.deferrable.callback {
                  EM.defer do
                    FileUtils.rm_f process_pcap.file
                  end
                }
              end

              tshark_deferrable.callback {
                EM::next_tick {
                  #not accurate but it helps to avoid overload the system with many childs
                  puts running_deferrables.size
                  next if running_deferrables.size > 3
                  EM.stop if pcap_queue.empty?
                  pcap_queue.pop(&worker_queue)
                }
              }
          end
        end
        pcap_queue.pop(&worker_queue)
      end #EM Reactor Loop
    end
  end
end
