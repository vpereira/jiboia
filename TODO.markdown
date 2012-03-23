* More specs
* Documentation (use cases)
* Break files bigger than 100 MB. Proposed Algorithm:
 - Break in N files. Each file with at max 1000 pkts
 - Process each file, breaking it in tcp/udp/others
 - remerge with merged pcap to have at end just one tcp, one udp and one others file
 - gzip it and prepare it to download
 - refactor the method PcapHelper::list_files
 - scheduler should accept the options from Whenever. Today we are updating the crontab file and not overwriting
