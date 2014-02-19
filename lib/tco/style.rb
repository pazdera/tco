# tco - terminal colouring application and library
# copyright (c) 2013, 2014 radek pazdera

# mit license

# permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "software"), to deal
# in the software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the software, and to permit persons to whom the software is
# furnished to do so, subject to the following conditions:

# the above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the software.

# the software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. in no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising from,
# out of or in connection with the software or the use or other dealings in
# the software.

module Tco
  class Style
    attr_accessor :fg, :bg, :bright, :underline

    def initialize(fg=nil, bg=nil, bright=false, underline=false)
      @fg = fg
      @bg = bg
      @bright = bright
      @underline = underline
    end

    def to_a
      [@fg, @bg, @bright, @underline]
    end

    def to_h
      {:fg => @fg, :bg => @bg, :bright => @bright, :underline => @underline}
    end

    def to_ary
      to_a
    end

    def ==(o)
      @fg == o.fg && @bg == o.bg && @bright == o.bright && @underline == o.underline
    end
  end
end
