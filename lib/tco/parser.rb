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
  class Token
    attr_reader :type

    def initialize(type, value)
      @type = type
      @value = value
    end

    def to_s
      @value
    end
  end

  class Segment
    attr_reader :value

    def initialize(value, params)
      @value = value
      @params = params
    end

    def to_s
      @value
    end
  end

  class Parser
    def initialize(default_params={})
      @default_params = default_params
    end

    def parse(string)
      lexer string
      p @tokens
      parse_tokens
    end

    private
    def submit_token(type, value)
      if type == :normal && @tokens.length > 0 && @tokens[-1].type == :normal
        prev = @tokens.pop
        @tokens.push Token.new :normal, prev.to_s + value
      else
        @tokens.push Token.new type, value
      end
    end

    def lexer(in_str)
      state = :default
      @tokens = []
      token = ""

      in_str.split("").each do |c|
        case state
        when :default
          case c
          when "c"
            state = :c

            submit_token :normal, token
            token = c
          when "s"
            state = :s

            submit_token :normal, token
            token = c
          when "/"
            submit_token :normal, token
            submit_token :end, c
            token = ""
          else
            token << c
          end
        when :c
          if c == "/"
            state = :c_fg
            token << c
          else
            state = :default
            token << c
            submit_token :normal, token
            token = ""
          end
        when :s
          if c == "/"
            state = :s_def
            token << c
          else
            state = :default
            token << c
            submit_token :normal, token
            token = ""
          end
        when :c_fg
          case c
          when "/"
            state = :c_bg
            token << c
          else
            token << c
          end
        when :c_bg
          case c
          when "/"
            state = :default
            token << c
            submit_token :colour, token
            token = ""
          else
            token << c
          end
        when :s_def
          case c
          when "/"
            state = :default
            token << c
            submit_token :style, token
            token = ""
          else
            token << c
          end
        end
      end
    end

    def parse_tokens
      segments = []
      params = @default_params

      stack = []
      @tokens.each do |t|
        case t.type
        when :colour
          prev_params = params
          stack.push params

          clex = t.to_s.split "/"
          params = {:fg => clex[1], :bg => clex[2],
                    :style => prev_params[:style]}
        when :style
          stack.push params
          clex = t.to_s.split "/"
          params = {:style => clex[1]}
        when :end
          params = stack.pop
        else
          seg = Segment.new t.to_s, params
          segments << seg
        end
      end
      segments
    end
  end
end
