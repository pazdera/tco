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
      @value == other.value && @params == other.params
    end
  end

  class Parser
    def initialize(default_style=nil)
      @default_params = {
        :base_style => nil,
        :fg => nil,
        :bg => nil,
        :bright => nil,
        :underline => nil
      }

      if default_style
        @default_params[:fg] = default_style.fg
        @default_params[:bg] = default_style.bg
        @default_params[:bright] = default_style.bright
        @default_params[:underline] = default_style.underline
      end
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

          params = prev_params.clone

          df = t.to_s[2..-1]
          if df.include? ":"
            c = df.split ":"
            c.push "" if df[-1] == ":"

            params[:fg] = c[0] unless c[0] == "" || c[0] == "-"
            params[:bg] = c[1] unless c[1] == "" || c[1] == "-"
            params[:bright] = true if c.length > 2 && c[2].include?("b")
            params[:underline] = true if c.length > 2 && c[2].include?("u")
          else
            params[:base_style] = df
            params[:fg] = nil
            params[:bg] = nil
            params[:bright] = nil
            params[:underline] = nil
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
