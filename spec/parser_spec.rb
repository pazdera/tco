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

    it "does basic parsing" do
      str = "{{blue:blue abc}} {{-:b ee}} {{fg: {{:bg cc}}dd}} ff"

      p @p.parse str
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
        Tco::Segment.new("London", get_params(nil, nil, nil, false, true)),
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
