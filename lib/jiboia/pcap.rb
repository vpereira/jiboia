module Jiboia
  class Pcap
    extend PcapHelper
    attr_reader :file,:dirname,:protocol

    def initialize(file,protocol = 'tcp')
      @file = file
      @protocol = protocol.to_sym
      @dirname = Pcap.get_or_create_dir
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
      case @protocol
        when :tcp
        "tcp"
        when :udp
          "udp"
        when :others
          "not tcp and not udp"
      end
    end

    def filename
      File.basename(@file,".cap")
    end
  end
end
