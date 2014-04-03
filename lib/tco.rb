# tco - terminal colouring application and library
# Copyright (c) 2013, 2014 Radek Pazdera

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "tco/version"
require "tco/config"
require "tco/colouring"
require "tco/style"
require "tco/parser"

module Tco
  @config = Config.new ["/etc/tco.conf", "~/.tco.conf"]
  @colouring = Colouring.new @config

  def self.colour(fg, bg, string)
    decorate string, Style.new(fg, bg)
  end

  def self.fg(colour, string)
    decorate string, Style.new(colour)
  end

  def self.bg(colour, string)
    decorate string, Style.new(nil, colour)
  end

  def self.bright(string)
    decorate string, Style.new(nil, nil, true, false)
  end

  def self.underline(string)
    decorate string, Style.new(nil, nil, false, true)
  end

  def self.style(style_name, string)
    @colouring.decorate(string, @colouring.get_style(style_name))
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

  def self.decorate(string, (fg, bg, bright, underline))
    @colouring.decorate string, [fg, bg, bright, underline]
  end

  def self.config
    @config
  end
  
  def self.configure
    c = config
    yield(c)
    reconfigure(c)
    c
  end

  def self.reconfigure(config)
    @config = config
    @colouring = Colouring.new config
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
      square_styles.each { |c, fg, bg| print Tco::colour fg, bg, " "*9 }
      puts

      # Colour index
      square_styles.each do |c, fg, bg|
        print Tco::colour fg, bg, c.to_s.center(9)
      end
      puts

      # Colour value
      square_styles.each do |c, fg, bg|
        print Tco::colour fg, bg, bg.to_s.center(9)
      end
      puts

      # Final empty line
      square_styles.each { |c, fg, bg| print Tco::colour fg, bg, " "*9 }
      puts
    end
  end
end

class String
  def decorate
    Tco::parse self, Tco::Style.new
  end

  def fg(colour)
    Tco::fg colour, self
  end

  def bg(colour)
    Tco::bg colour, self
  end

  def bright
    Tco::bright self
  end

  def underline
    Tco::underline self
  end

  def style(style)
    Tco::style style, self
  end
end
