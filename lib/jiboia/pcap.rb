module Jiboia
  class Pcap
    extend PcapHelper
    attr_reader :file,:dirname,:protocol

    def initialize(file,protocol = 'tcp', port = 0)
      @file = file
      @protocol = protocol.to_sym
      @dirname = Pcap.get_or_create_dir
      @port = port
    end
    #
    #it returns a EM::Deferrable
    def run
      puts "i will process #{@protocol.to_s} with filter: #{filter}"
      tshark_deferrable = EM::DeferrableChildProcess.open("#{Jiboia::tshark} -r #{@file} -w #{output_filename} #{filter}")
    end

    def output_filename
      "#{@dirname}/#{filename}_#{@protocol.to_s}.cap"
    end

    private

    def filter
      local_f = case @protocol
        when :tcp
          "tcp"
        when :udp
          "udp"
        when :others
          "not tcp and not udp"
      end
      local_f += " and port #{@port}" unless @port == 0
      local_f
    end

    def filename
      File.basename(@file,".cap")
    end
  end
end
