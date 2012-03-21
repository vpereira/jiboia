module Jiboia
  class Dumpcap
    class << self
      #TODO
      #define it as config options
      #check if we are root
      def run(args = {:device=>"eth0",:fname=>"packets.cap"})
        
        if Process.uid != 0
          puts "You must be root"
          Process.exit false
        end
        
        pid = fork do
          Dir.chdir(Jiboia::root_dir)
          exec Jiboia::dumpcap, "-i #{args[:device]} -b duration:3600 -b files:25 -w #{args[:fname]}"
        end
        #Detach it and let the process free as a bird 
        Process.detach(pid)
        pid
      end
    end
  end
end