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
