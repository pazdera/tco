#!/usr/bin/env ruby

require "tco"

flag = <<-EOS
RRR    BBBBBBBBBB  RR  BBBBBBBBBB    RRR
  RR     BBBBBBBB  RR  BBBBBBBB     RR  
B   RR     BBBBBB  RR  BBBBBB     RR   B
BBB   RR     BBBB  RR  BBBB     RR   BBB
BBBBB   RR    BBB  RR  BBB    RR   BBBBB
                   RR                   
RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
                   RR                   
BBBBB   RR    BBB  RR  BBB    RR   BBBBB
BBB   RR     BBBB  RR  BBBB     RR   BBB
B   RR     BBBBBB  RR  BBBBBB     RR   B
  RR     BBBBBBBB  RR  BBBBBBBB     RR  
RRR    BBBBBBBBBB  RR  BBBBBBBBBB    RRR
EOS

flag.split("").each do |c|
  case c
  when "R" then print " ".bg "#c9120a"
  when "B" then print " ".bg "#10116d"
  when " " then print " ".bg "#ffffff"
  when "\n" then print "\n"
  end
end
