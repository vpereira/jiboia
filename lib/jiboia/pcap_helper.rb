module Jiboia
  module PcapHelper
    
    def timestamp_to_directory(timestamp = Time.now)
      timestamp.strftime("%Y%m%d")
    end
    #relative path to Jiboia::root_dir
    def directory_exists?(timestamp)
      File.exists? File.join(Jiboia::rot_dir,timestamp)
    end
  
    #relative path to Jiboia::root_dir
    #default extension = 'cap.gz'
    def file_exists?(file,directory,ext = 'cap.gz')
      File.exists? File.join(Jiboia::rot_dir,timestamp,file,ext)
    end

    def get_or_create_dir(timestamp = Time.now)
        dirname = File.join(Jiboia::root_dir,timestamp_to_directory)
        FileUtils.mkdir(dirname) unless File.exists? dirname
        dirname
    end

    def list_files(dirname = nil)
      #as default we are dealing with ROOT DIR
      root_dir = true
      if dirname.nil?
        dirname = Jiboia.root_dir
      else 
        root_dir = false
        #if the dirname isnt a timestamp, as we save it, then we just ignore it and interpret the request as to root_dir
        if dirname.match /^\d+$/
          dirname = File.join(Jiboia.root_dir,dirname) 
        else
          root_dir = true
          dirname = Jiboia.root_dir
        end
      end
      
      puts dirname
      
      filter_str = root_dir ? "*.cap" : "*.cap.gz" 
      #todo check if i can pass the match used below already here
      Dir.glob(File.join(dirname,filter_str)).find_all do |f|
        if root_dir 
          f.match /.*packets_\d+_\d+[^_.*].cap$/
        else
          f.match /.*packets_\d+_\d+_(tcp|udp|others).cap.gz$/
        end
      end
    end
  end
end
