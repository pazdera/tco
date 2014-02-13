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

require "tco/version"
require "tco/config"
require "tco/colours"
require "tco/style"

module Tco
  @configuration = Configuration.new
  @colours = Colours.new @configuration

  def self.decorate(string, (fg, bg, bright, underline))
    @colours.decorate string, [fg, bg, bright, underline]
  end

  def self.colour(string, fg=nil, bg=nil)
    @colours.decorate(string, Style.new(fg, bg, false, false))
  end

  def self.bright(string)
    @colours.decorate(string, Style.new(nil, nil, true, false))
  end

  def self.underline(string)
    @colours.decorate(string, Style.new(nil, nil, false, true))
  end

  def self.style(string, style_name)
    @colours.style string, style_name
  end

  def self.define_style(name, fg=nil, bg=nil, bright=false, underline=false)
    @colours.define_style name, fg, bg, bright, underline
  end

  def self.define_name(name, colour_def)
    @colours.define_name name, colour_def
  end

  def self.get_available_colours
    @colours.get_available_colours
  end

  def self.use_palette(type)
    @colours.set_palette(type)
  end

  def self.parse(string, default_style)
    p = Parser.new @colours, @default_style
    p.parse
  end
end
