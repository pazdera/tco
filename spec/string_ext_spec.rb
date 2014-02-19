require "tco"
require "tco/config"

describe Tco do
  describe "String class extension" do
    before :all do
      config = Tco::Config.new
      config.options["palette"] = "extended"
      config.options["output"] = "raw"
      Tco::reconfigure config
    end

    describe "#fg" do
      it "works with rgb" do
        result = "London".fg "@"
      end

      it "works with hex" do
      end

      it "works with names" do
      end
    end

    describe "#bg" do
      it "works with rgb" do
      end

      it "works with hex" do
      end

      it "works with names" do
      end
    end

    it "" do
    end

    it "" do
    end

    it "" do
    end

    it "" do
    end
  end
end
