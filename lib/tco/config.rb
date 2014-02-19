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

            if styledef.has_key? "fg"
              style[:fg] = styledef["fg"]
            end

            if styledef.has_key? "bg"
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
