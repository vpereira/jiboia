require 'spec_helper'

describe "Jiboia Configuration" do
  
  
  it "must respond to read_config" do 
      Jiboia.must_respond_to :read_config
  end
  
  it "must have a tshark path" do
    Jiboia.tshark.wont_be_nil
  end
  
  it "must have a gzip path" do
    Jiboia.gzip.wont_be_nil
  end
  
  it "must have a dumpcap path" do
    Jiboia.dumpcap.wont_be_nil
  end
  
  it "must have a root_dir path" do
    Jiboia.root_dir.wont_be_nil
  end
  
end