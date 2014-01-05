require "tco"

describe Tco do
  describe Tco::Colour do
    before :each do
      @colour = Tco::Colour.new [12, 34, 56]
    end

    it "converts to HSL" do
      hsl = @colour.hsl
      hsl[0].should be_within(0.1).of 210
      hsl[1].should be_within(0.1).of 64.7
      hsl[2].should be_within(0.1).of 13.3
    end
  end
end
