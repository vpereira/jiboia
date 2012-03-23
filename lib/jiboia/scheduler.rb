module Jiboia
  class Scheduler
    class << self
      def run
        Whenever::CommandLine.execute({:update=>true,:file=>File.join(Jiboia.root_dir,"..","config","schedule.rb")})
      end
    end
  end
end