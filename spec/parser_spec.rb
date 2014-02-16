require "tco/parser"

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
        Tco::Segment.new("London", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with fg colour only" do
      string = "The City of {{grey: London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("London", {:fg => "grey", :bg => nil, :style => nil}),
        Tco::Segment.new(", UK", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with bg colour only" do
      string = "The City of {{-:red London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("London", {:fg => nil, :bg => "red", :style => nil}),
        Tco::Segment.new(", UK", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with both colours" do
      string = "The City of {{grey:red London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("London", {:fg => "grey", :bg => "red", :style => nil}),
        Tco::Segment.new(", UK", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "works with a style" do
      string = "The City of {{alert London}}, UK"
      expected = [
        Tco::Segment.new("The City of ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("London", {:fg => nil, :bg => nil, :style => "alert"}),
        Tco::Segment.new(", UK", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "can be nested" do
      string = "The {{alert City of {{grey:red London}},}} UK"
      expected = [
        Tco::Segment.new("The ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("City of ", {:fg => nil, :bg => nil, :style => "alert"}),
        Tco::Segment.new("London", {:fg => "grey", :bg => "red", :style => "alert"}),
        Tco::Segment.new(",", {:fg => nil, :bg => nil, :style => "alert"}),
        Tco::Segment.new(" UK", {:fg => nil, :bg => nil, :style => nil})
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "doesn't process empty template" do
      string = "London {{}}"
      expected = [
        Tco::Segment.new("London {{}}", {:fg => nil, :bg => nil, :style => nil}),
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "doesn't process template without a space" do
      string = "{{grey:redLondon}}"
      expected = [
        Tco::Segment.new("{{grey:redLondon}}", {:fg => nil, :bg => nil, :style => nil}),
      ]

      segments = @p.parse string
      segments.should == expected
    end

    it "ignores mismatched endings" do
      string = "}} {{grey:red London}} }}"
      expected = [
        Tco::Segment.new("}} ", {:fg => nil, :bg => nil, :style => nil}),
        Tco::Segment.new("London", {:fg => "grey", :bg => "red", :style => nil}),
        Tco::Segment.new(" }}", {:fg => nil, :bg => nil, :style => nil}),
      ]

      segments = @p.parse string
      segments.should == expected
    end
  end
end
