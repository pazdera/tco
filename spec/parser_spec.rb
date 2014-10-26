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

require "utils"

require "tco/parser"

RSpec.configure do |c|
  c.include Utils
end

describe Tco do
  describe Tco::Parser do
    before :all do
      @p = Tco::Parser.new
    end

    it "handles no definitions" do
      string = "London"
      expected = [
        Tco::Segment.new("London", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with fg colour only" do
      string = "The City of {{grey: London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params(nil, "grey")),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with bg colour only" do
      string = "The City of {{-:red London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params(nil, nil, "red")),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with both colours" do
      string = "The City of {{grey:red London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params(nil, "grey", "red")),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "makes it bold" do
      string = "The City of {{::b London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params(nil, nil, nil, true)),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "underlines the text" do
      string = "The City of {{::u London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params(nil, nil, nil, nil, true)),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with a style" do
      string = "The City of {{alert London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", get_params),
        Tco::Segment.new("London", get_params("alert")),
        Tco::Segment.new(", UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "can be nested" do
      string = "The {{alert City of {{grey:red London}},}} UK"
      expected = [
        Tco::Segment.new("The ", get_params),
        Tco::Segment.new("City of ", get_params("alert")),
        Tco::Segment.new("London", get_params("alert", "grey", "red")),
        Tco::Segment.new(",", get_params("alert")),
        Tco::Segment.new(" UK", get_params)
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "doesn't process empty template" do
      string = "London {{}}"
      expected = [
        Tco::Segment.new("London {{}}", get_params),
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "doesn't process template without a space" do
      string = "{{grey:redLondon}}"
      expected = [
        Tco::Segment.new("{{grey:redLondon}}", get_params),
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "ignores mismatched endings" do
      string = "}} {{grey:red London}} }}"
      expected = [
        Tco::Segment.new("}} ", get_params),
        Tco::Segment.new("London", get_params(nil, "grey", "red")),
        Tco::Segment.new(" }}", get_params),
      ]

      segments = @p.parse string
      segments.should == expected
    end
  end
end
