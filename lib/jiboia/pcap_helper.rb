module Jiboia
  module PcapHelper
    
    def get_or_create_dir(timestamp = Time.now)
        dirname = File.join(Jiboia::root_dir,timestamp.strftime("%Y%m%d"))
        FileUtils.mkdir(dirname) unless File.exists? dirname
        dirname
    end

    def list_files
      Dir.glob(File.join(Jiboia.root_dir,"*.cap")).find_all do |f|
          f.match /.*packets_\d+_\d+[^_.*].cap$/
      end
    end
  end
end
