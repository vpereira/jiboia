module Jiboia
  class Scheduler
    class << self
      def run
        Whenever::CommandLine.execute({:write=>true})
      end
    end
  end
end