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
    attr_reader :value, :params

    def initialize(value, params)
      @value = value
      @params = params
    end

    def to_s
      @value
    end

    # For rspec assertions
    def ==(other)
      @value == other.value and @params == other.params
    end
  end

  class Parser
    def initialize(default_params={:fg => nil, :bg => nil, :style => nil})
      @default_params = default_params
    end

    def parse(string)
      lexer string
      parser
      @segments
    end

    private
    def submit_token(type, value)
      return if value == ""

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
          when "{"
            submit_token :normal, token
            token = c

            state = :o_br
          when "}"
            submit_token :normal, token
            token = c

            state = :c_br
          else
            token << c
          end
        when :o_br
          case c
          when "{"
            state = :definition
          else
            state = :default
          end
          token << c
        when :definition
          case c
          when /[a-zA-Z0-9\:\-#]/
            token << c
          when /\s/
            submit_token :definition, token
            token = ""

            state = :default
          else
            token << c
            state = :default
          end
        when :c_br
          token << c
          if c == "}"
            submit_token :end, token
            token = ""
          end
          state = :default
        end
      end
      submit_token :normal, token unless token == ""
    end

    def add_segment(t, params)
      return if t.to_s == ""

      if @segments.length > 0 && @segments[-1].params == params
        prev = @segments.pop
        @segments.push Segment.new prev.to_s + t.to_s, params
      else
        @segments.push Segment.new t.to_s, params
      end
    end

    def parser
      @segments = []
      params = @default_params

      stack = []
      @tokens.each do |t|
        case t.type
        when :definition
          prev_params = params
          stack.push params

          params = {
            :fg => prev_params[:fg],
            :bg => prev_params[:bg],
            :bright => prev_params[:bright],
            :underline => prev_params[:underline],
            :style => prev_params[:style]
          }

          df = t.to_s[2..-1]
          if df.include? ":"
            c = df.split ":"
            c.push "" if df[-1] == ":"

            params[:fg] = c[0] unless c[0] == "" || c[0] == "-"
            params[:bg] = c[1] unless c[1] == "" || c[1] == "-"
            params[:bright] = true if c.length > 2 && c[2].include?("b")
            params[:underline] = true if c.length > 2 && c[2].include?("u")
          else
            params[:fg] = nil
            params[:bg] = nil
            params[:style] = df
          end
        when :end
          if stack.length > 0
            params = stack.pop
          else
            add_segment t, params
          end
        else
          add_segment t, params
        end
      end
    end
  end
end
