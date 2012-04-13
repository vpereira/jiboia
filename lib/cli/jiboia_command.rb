require 'thor'

class JiboiaCommand < Thor
  desc "process_pcap_files", "process one single pcap file or a directory with many pcap files"
  method_option :with_file, :type=>:string,:aliases=>"-f", :banner=>'file',:desc=> "process and parse a specific file"
  method_option :with_directory, :type=>:string, :aliases=>"-d", :banner=>'directory', :desc=> "process and parse all files in the specific directory"
  method_option :zip_files_after, :aliases=>"-z", :type=>:boolean,:desc=>"zip all generated files after",:default=>true
  method_option :keep_files, :aliases=>"-k", :type=>:boolean,:desc=>"keep the raw pcap files after processing",:default=>true
  def process_pcap_files
    Jiboia.run(options)
  end
end

