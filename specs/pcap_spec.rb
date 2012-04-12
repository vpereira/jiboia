require 'spec_helper'

include Jiboia

describe Pcap do
  before do
    @pcap = Pcap.new('/fe/fi/foo.cap')
  end
  subject { @pcap }
  it "should not be nil" do
    wont_be_nil
  end
  describe "read accessor protocol" do
    it "must have a default value" do
     Pcap.new('foo.txt').protocol.must_match /tcp/
    end
  end

  describe "dirname cannot be nil" do
    before do
      Pcap.stubs(:get_or_create_dir).returns("/x/#{@pcap.file}")
    end
    it "dirname cannot be nil" do
      @pcap.dirname.wont_be_nil
    end
  end
  it "should return a output filename" do
    @pcap.output_filename.must_match /foo_tcp.cap$/
  end
  it "should return a EM:Deferrable" do
    #skip "problem with EM"
    EM.run {
      @pcap.run.must_be_instance_of EM::DeferrableChildProcess
      EM.stop
    }
  end
end
