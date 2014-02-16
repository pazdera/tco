# tco - terminal colouring application and library
# Copyright (C) 2013 Radek Pazdera
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
  end
end
