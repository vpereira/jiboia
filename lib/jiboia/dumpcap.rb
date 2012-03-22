module Jiboia
  class Dumpcap
    class << self
      #TODO
      #define it as config options
      def run(args = {:device=>"eth0",:fname=>"packets.cap"})
              
        if Process.uid != 0
          puts "You must be root"
          Process.exit false
        end
        
        puts "#{Jiboia::dumpcap} -i #{args[:device]} -b duration:3600 -b files:25 -w #{args[:fname]} -p -q"
        pid = fork do
          Dir.chdir(Jiboia::root_dir)
          #we dont put the interface in promiscuous mode and we set the silent mode
          exec Jiboia::dumpcap, "-i #{args[:device]} -b duration:3600 -b files:25 -w #{args[:fname]} -p -q"
        end
        #Detach it and let the process free as a bird 
        Process.detach(pid)
        pid
      end
    end
  end
end