## Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 1.day, :at=>'00:00' do
  command "cd #{File.expand_path(File.join(File.dirname(__FILE__),'..'))} && #{File.expand_path(File.join(File.dirname(__FILE__),'..','bin','dumpcap.rb'))}"
end

if @single_file_process
  every 1.hour, :at=>'01:01' do
    #here we call the Jiboia run saying it to parse the   
  end
end
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
