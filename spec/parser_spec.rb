require "tco/parser"

describe Tco do
  describe Tco::Parser do
    #before :each do
    #  @colour = Tco::Colour.new [12, 34, 56]
    #end

    it "does basic parsing" do
      #str = '#{blue:blue abc} #{alert aaa}'
      str = "c/blue/blue/abc/ s/alert/aaa/ s/dodo/weec/red/red/pho//"

      pr = Tco::Parser.new

      segments = pr.parse str
      p segments
    end
  end
end
