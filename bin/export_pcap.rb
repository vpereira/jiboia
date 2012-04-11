#!/usr/bin/env ruby

require 'rubygems'
#require 'mongodb'
require 'packetfu'
require 'json'

include PacketFu
def export_pcap(file)
	PcapFile.read_packets(file) do |pkt|
    packet_hash = {}
    packet = Packet.parse(pkt)

    if pkt.is_ip?
      packet_hash =  {ip_saddr:pkt.ip_saddr, ip_daddr: pkt.ip_daddr, ip_len: pkt.ip_len,pkt_size: pkt.size,protocols: pkt.proto,ip_proto: pkt.proto.last}

      layer4_hash = case 
        when pkt.is_tcp?
          {src_port: pkt.tcp_src, dst_port: pkt.tcp_dst, payload: pkt.hexify(pkt.payload)}         
        when pkt.is_udp?
          {src_port: pkt.udp_src, dst_port: pkt.udp_dst, payload: pkt.hexify(pkt.payload)}
        when pkt.is_icmp?
          {icmp_type: pkt.icmp_type, icmp_code: pkt.icmp_code, payload: pkt.hexify(pkt.payload)}
        else
          {}
      end
      packet_hash.merge! layer4_hash unless layer4_hash.nil? 
     end
     puts packet_hash.to_json unless packet_hash.empty?
	end
end
if File.readable?(infile = (ARGV[0] || 'in.pcap'))
	title = "Packets by packet type in '#{infile}'"
	puts "-" * title.size
	puts title
	puts "-" * title.size
	export_pcap(infile)
else
	raise RuntimeError, "Need an infile, like so: #{$0} in.pcap"
end

