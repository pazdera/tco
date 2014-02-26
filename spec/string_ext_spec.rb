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
      it "works with references" do
        result = "London".fg "@17"
        result.should eql "\e[38;5;17mLondon\e[0m"
      end

      it "works with rgb" do
        result = "London".fg "#00005f"
        result.should eql "\e[38;5;17mLondon\e[0m"
      end

      it "works with hex" do
        result = "London".fg "0x00005f"
        result.should eql "\e[38;5;17mLondon\e[0m"
      end

      it "works with names" do
        result = "London".fg "black"
        result.should eql "\e[38;5;0mLondon\e[0m"
      end
    end

    describe "#bg" do
      it "works with references" do
        result = "London".bg "@17"
        result.should eql "\e[48;5;17mLondon\e[0m"
      end

      it "works with rgb" do
        result = "London".bg "#00005f"
        result.should eql "\e[48;5;17mLondon\e[0m"
      end

      it "works with hex" do
        result = "London".bg "0x00005f"
        result.should eql "\e[48;5;17mLondon\e[0m"
      end

      it "works with names" do
        result = "London".bg "black"
        result.should eql "\e[48;5;0mLondon\e[0m"
      end
    end

    describe "#bright" do
      it "makes the fond bold" do
        result = "London".bright
        result.should eql "\e[1mLondon\e[0m"
      end
    end

    describe "#underline" do
      it "underlines the text" do
        result = "London".underline
        result.should eql "\e[4mLondon\e[0m"
      end
    end

    it "can be combined" do
      result = "London".bright.underline.fg("@17").bg("@17")
      result.should eql "\e[48;5;17m\e[38;5;17m\e[4m\e[1mLondon\e[0m\e[0m\e[0m\e[0m"
    end

    describe "#decorate" do
      it "processes templates" do
        result = " {{::u London}} ".decorate
        result.should eql " \e[4mLondon\e[0m "
      end
    end
  end
end
