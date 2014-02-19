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
require "tco/colouring"
require "tco/style"
require "tco/parser"

module Tco
  @config = Config.new ["/etc/tco.conf", "~/.tco.conf"]
  @colouring = Colouring.new @config

  def self.config
    @config
  end

  def self.reconfigure(config)
    @config = config
    @colouring = Colouring.new @config
  end

  def self.decorate(string, (fg, bg, bright, underline))
    @colouring.decorate string, [fg, bg, bright, underline]
  end

  def self.colour(string, fg=nil, bg=nil)
    decorate(string, Style.new(fg, bg, false, false))
  end

  def self.bright(string)
    decorate(string, Style.new(nil, nil, true, false))
  end

  def self.underline(string)
    decorate(string, Style.new(nil, nil, false, true))
  end

  def self.style(string, style_name)
    @colouring.style string, style_name
  end

  def self.get_style(style_name)
    @colouring.get_style style_name
  end

  def self.parse(string, default_style)
    p = Parser.new default_style
    segments = p.parse string

    output = ""
    segments.each do |seg|
      style = if seg.params[:base_style]
                @colouring.get_style seg.params[:base_style]
              else
                Style.new
              end

      style.fg = seg.params[:fg]
      style.bg = seg.params[:bg]
      style.bright = seg.params[:bright]
      style.underline = seg.params[:underline]

      output << decorate(seg.to_s, style)
    end
    output
  end

  def self.display_palette
    # TODO: Might be worth sorting, so the pallete is easier to navigate
    colours = @colouring.palette.colours
    colours_per_line = (`tput cols`.to_i / 9 - 0.5).ceil

    c = 0
    while c < colours.length do
      if (c + colours_per_line) < colours.length
        squares = colours_per_line
      else
        squares = colours.length - c
      end

      # Prepare the squares for the line
      square_styles = []
      squares.times do
        black = Tco::Colour.new([0,0,0])
        white = Tco::Colour.new([255,255,255])

        font_colour = if (colours[c] - black).abs > (colours[c] - white).abs
                        black
                      else
                        white
                      end

        square_styles.push [c, font_colour, colours[c]]
        c += 1
      end

      # The first empty line
      square_styles.each { |c, fg, bg| print Tco::colour " "*9, fg, bg }
      puts

      # Colour index
      square_styles.each do |c, fg, bg|
        print Tco::colour c.to_s.center(9), fg, bg
      end
      puts

      # Colour value
      square_styles.each do |c, fg, bg|
        print Tco::colour bg.to_s.center(9), fg, bg
      end
      puts

      # Final empty line
      square_styles.each { |c, fg, bg| print Tco::colour " "*9, fg, bg }
      puts
    end
  end
end

class String
  def fg(colour)
    Tco::colour self, colour
  end

  def bg(colour)
    Tco::colour self, nil, colour
  end

  def bright
    Tco::bright self
  end

  def underline
    Tco::underline self
  end

  def style(style)
    Tco::style self, style
  end
end
