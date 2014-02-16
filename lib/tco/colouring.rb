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

require 'tco/palette'
require 'tco/style'

module Tco
  class Colouring
    ANSI_FG_BASE = 30
    ANSI_BG_BASE = 40

    attr_reader :palette

    def initialize(configuration)
      @palette = Palette.new configuration.options["palette"]
      @output_type = configuration.options["output"]

      configuration.colour_values.each do |id, value|
        @palette.set_colour_value(parse_colour_id(id), parse_rgb_value(value))
      end

      @names = {}
      configuration.names.each do |name, colour_def|
        @names[name] = resolve_colour_def colour_def
      end

      @styles = {}
      configuration.styles.each do |name, style|
        @styles[name] = Style.new(resolve_colour_def(style[:fg]),
                                  resolve_colour_def(style[:bg]),
                                  style[:bright], style[:underline])
      end
    end

    # Decorate a string according to the style passed. The input string
    # is processed line-by-line (the escape sequences are added to each
    # line). This is due to some problems I've been having with some
    # terminal emulators not handling multi-line coloured sequences well.
    def decorate(string, (fg, bg, bright, underline))
      return string unless STDOUT.isatty || @output_type == :raw

      fg = to_colour fg
      bg = to_colour bg

      output = []
      lines = string.lines.map(&:chomp)
      lines.each do |line|
        unless line.length <= 0
          line = case @palette.type
                 when "ansi" then colour_ansi line, fg, bg
                 when "extended" then colour_extended line, fg, bg
                 else raise "Unknown palette '#{@palette.type}'."
                 end

          if bright
            line = e(1) + line
          end

          if underline
            line = e(4) + line
          end

          if (bright or underline) and fg == nil and bg == nil
            line << e(0)
          end
        end

        output.push line
      end

      output << "" if string =~ /\n$/
      output.join "\n"
    end

    #def define_style(name, fg=nil, bg=nil, bright=false, underline=false)
    #  @styles[name] = Style.new(fg, bg, bright, underline)
    #end

    #def define_name(name, colour_def)
    #  @names[name] = resolve_colour_def colour_def
    #end

    def get_style(name)
      raise "Style '#{name}' not found." unless @styles.has_key? name

      @styles[name]
    end

    def set_output(output_type)
      raise "Output '#{output_type}' not supported." unless [:term, :raw].include? output_type
      @output_type = output_type
    end

    private
    def e(seq)
      if @output_type == :raw
        "\\033[#{seq}m"
      else
        "\033[#{seq}m"
      end
    end

    def colour_ansi(string, fg=nil, bg=nil)
      unless fg == nil
        colour_id = @palette.match_colour(fg)
        string = e(colour_id + 30) + string
      end

      unless bg == nil
        colour_id = @palette.match_colour(bg)
        string = e(colour_id + 40) + string
      end

      unless fg == nil and bg == nil
        string << e(0)
      end

      string
    end

    def colour_extended(string, fg=nil, bg=nil)
      unless fg == nil
        colour_id = @palette.match_colour(fg)
        string = e("38;5;#{colour_id}") + string
      end

      unless bg == nil
        colour_id = @palette.match_colour(bg)
        string = e("48;5;#{colour_id}") + string
      end

      unless fg == nil and bg == nil
        string << e(0)
      end

      string
    end

    def parse_colour_id(id_in_string)
      id = String.new(id_in_string)
      if id[0] == '@'
        id[0] = ''
        return id.to_i
      end

      raise "Invalid colour id #{id_in_string}."
    end

    def parse_rgb_value(rgb_value_in_string)
      error_msg = "Invalid RGB value '#{rgb_value_in_string}'."
      rgb_value = String.new rgb_value_in_string
      case
      when rgb_value[0] == '#'
        rgb_value[0] = ''
      when rgb_value[0..1] == '0x'
        rgb_value[0..1] = ''
      else
        raise error_msg
      end

      case rgb_value.length
      when 3
        rgb_value.scan(/./).map { |c| c.to_i 16 }
      when 6
        rgb_value.scan(/../).map { |c| c.to_i 16 }
      else
        raise error_msg
      end
    end

    def resolve_colour_name(name)
      raise "Name '#{name}' not found." unless @names.has_key? name

      @names[name]
    end

    def resolve_colour_def(colour_def)
      return nil if colour_def == ""
      begin
        @palette.get_colour_value parse_colour_id colour_def
      rescue RuntimeError
        begin
          parse_rgb_value colour_def
        rescue RuntimeError
          begin
            colour_def = resolve_colour_name colour_def
            if colour_def.is_a? String
              resolve_colour_def colour_def
            else
              colour_def
            end
          rescue RuntimeError
            raise "Invalid colour definition '#{colour_def}'."
          end
        end
      end
    end

    def to_colour(value)
      rgb = case
            when value.is_a?(String) then resolve_colour_def value
            when value.is_a?(Array) then value
            when value.is_a?(Colour) then value.rgb
            when value == nil then return nil
            else raise "Colour value type '#{value.class}' not supported."
            end

      Colour.new rgb
    end
  end
end
