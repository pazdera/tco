require "yaml"

module Tco
  DEFAULT_CONFIG_PATH = "~/.tco-conf"
  @configuration = {
    :options => {
      :palette => "auto", # auto, ansi, extended

      :ansi_colours => {
        "@0" => 0x000000,
        "@1" => 0xCC0000,
        "@2" => 0x4E9A06,
        "@3" => 0xC4A000,
        "@4" => 0x3465A4,
        "@5" => 0x75507B,
        "@6" => 0x06989A,
        "@7" => 0xD3D7CF,
        "@8" => 0x555753,
        "@9" => 0xEF2929,
        "@10" => 0x8AE234,
        "@11" => 0xFCE94F,
        "@12" => 0x729FCF,
        "@13" => 0xAD7FA8,
        "@14" => 0x34E2E2,
        "@15" => 0xEEEEEC
      },
    },

    :aliases => {
      "black" => "@0",
      "red" => "@1",
      "green" => "@2",
      "yellow" => "@3",
      "blue" => "@4",
      "magenta" => "@5",
      "cyan" => "@6",
      "light-gray" => "@7",
      "dark-gray" => "@8",
      "light-red" => "@9",
      "light-green" => "@10",
      "light-yellow" => "@11",
      "light-blue" => "@12",
      "light-magenta" => "@13",
      "light-cyan" => "@14",
      "white" => "@15"
    },

    :presets => {
      "alert" => ["red", "default", true, false]
    }
  }

  def self.load_config(path=DEFAULT_CONFIG_PATH)
    puts @configuration
    return unless File.exists? path
  end
end
