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

require 'yaml'

module Tco
  class Config
    attr_accessor :options, :colour_values, :names, :styles

    def initialize(locations=[])
      @options = {
        "palette" => "extended",
        "output"  => "term"
      }
      @colour_values = {}
      @names = {
        "black" => "@0",
        "red" => "@1",
        "green" => "@2",
        "yellow" => "@3",
        "blue" => "@4",
        "magenta" => "@5",
        "cyan" => "@6",
        "light-grey" => "@7",
        "grey" => "@8",
        "light-red" => "@9",
        "light-green" => "@10",
        "light-yellow" => "@11",
        "light-blue" => "@12",
        "light-magenta" => "@13",
        "light-cyan" => "@14",
        "white" => "@15"
      }

      @styles = {}

      locations.each do |conf_file|
        conf_file = File.expand_path conf_file
        next unless File.exists? conf_file
        load conf_file
      end
    end

    def load(path)
      conf_file = YAML::load_file path

      if conf_file.has_key? "options"
        if conf_file["options"].is_a? Hash
          conf_file["options"].each do |id, value|
            @colour_values[id] = value
          end
        else
          raise "The 'colour_values' config option must be a hash."
        end
      end

      if conf_file.has_key? "colour_values"
        if conf_file["colour_values"].is_a? Hash
          conf_file["colour_values"].each do |id, value|
            @colour_values[id] = value
          end
        else
          raise "The 'colour_values' config option must be a hash."
        end
      end

      if conf_file.has_key? "names"
        if conf_file["names"].is_a? Hash
          conf_file["names"].each do |name, colour|
            @names[name] = colour
          end
        else
          raise "Invalid format of the 'names' option."
        end
      end

      if conf_file.has_key? "styles"
        if conf_file["styles"].is_a? Hash
          conf_file["styles"].each do |name, styledef|
            style = {:fg => nil, :bg => nil, :bright => false,
                     :underline => false}

            if styledef.has_key? "fg" && styledef["fg"] != "default"
              style[:fg] = styledef["fg"]
            end

            if styledef.has_key? "bg" && styledef["bg"] != "default"
              style[:bg] = styledef["bg"]
            end

            if styledef.has_key? "bright"
              style[:bright] = parse_bool styledef["bright"]
            end

            if styledef.has_key? "underline"
              style[:underline] = parse_bool styledef["underline"]
            end

            @styles[name] = style
          end
        else
          raise "Invalid format of the 'styles' option."
        end
      end
    end

    private
    def name_exists?(colour_name)
      @names.has_key? colour_name
    end

    def parse_bool(value)
     return true if value =~ /true/i || value =~ /yes/i || value.to_i >= 1
     return false
    end
  end
end
