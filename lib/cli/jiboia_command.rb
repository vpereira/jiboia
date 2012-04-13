require 'thor'

class JiboiaCommand < Thor
  desc "process_pcap_files", "process one single pcap file or a directory with many pcap files"
  method_option :with_file, :type=>:string,:aliases=>"-f", :banner=>'file',:desc=> "process and parse a specific file"
  method_option :with_directory, :type=>:string, :aliases=>"-d", :banner=>'directory', :desc=> "process and parse all files in the specific directory"
  method_option :zip_files_after, :aliases=>"-z", :type=>:boolean,:desc=>"zip all generated files after",:default=>true
  def process_pcap_files
    if options[:with_file]
      puts options[:with_file]
    else
      puts options[:with_directory]
    end
  end
end

