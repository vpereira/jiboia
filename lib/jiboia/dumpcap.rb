module Jiboia
  class Dumpcap
    
    DEFAULT_VALUES = {:device=>"eth0",:fname=>"packets.cap"}
    class << self
      #TODO
      #define it as config options
      def run(args = {} )
        
        args.merge!(DEFAULT_VALUES)
        
        if Process.uid != 0
          puts "You must be root"
          Process.exit false
        end
        
        #puts "#{Jiboia::dumpcap} -i #{args[:device]} -b duration:3600 -b files:25 -w #{args[:fname]} -p"
        pid = fork do
          Dir.chdir(Jiboia::root_dir)
          #we dont put the interface in promiscuous mode and we set the silent mode
          Process.exec Jiboia::dumpcap, "-i", "#{args[:device]}", "-b", "duration:3600", "-b","files:25","-w","#{File.join(Jiboia.root_dir,args[:fname])}" ,"-p"
        end
        #Detach it and let the process free as a bird 
        Process.detach(pid)
        pid
      end
    end
  end
end