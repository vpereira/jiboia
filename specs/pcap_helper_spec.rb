require 'spec_helper'

include Jiboia

describe PcapHelper do
  
  before do
    @klass = class Foo; extend PcapHelper; end
  end
  
  describe "class methods" do
    it "should return a string with format %Y%m%d " do
      @klass.timestamp_to_directory.must_match /^\d+$/
    end
  end
end