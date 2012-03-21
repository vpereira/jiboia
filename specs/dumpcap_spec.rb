require 'spec_helper'

include Jiboia

describe Dumpcap do
  it "should respond to run" do
    Dumpcap.must_respond_to :run
  end

  #it must raise something if we are running it as ordinary user without root power
end