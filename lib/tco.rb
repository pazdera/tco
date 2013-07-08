require "tco/version"
require "tco/config"

module Tco
  CLEAR = "\e[0m"
  BOLD = "\e[1m"
  UNDERLINE = "\e[4m"

  def self.bold(string)
    BOLD << string << CLEAR
  end

  def self.underline(string)
    UNDERLINE << string << CLEAR
  end

  def colour_to_fg_code_ansi(colour)
  end

  def colour_to_bg_code_ansi(colour)
  end

  def colour_to_fg_code_ext(colour)
  end

  def colour_to_bg_code_ext(colour)

  def get_colour_code(colour, palette)
    #
    # - colour definitions:
    #     "default"
    #     "@2"
    #     "#00ff00"
    #     "alias"
    #     0x00ff00
    #
    # - check the type
    #   - int: RGB
    #   - string:
    #     - check the first char
    #       - @ - get RGB from config
    #       - # - RGB
    #     - default
    #     - search through aliases
    #       - repeat
    #
    # - translate the colour definition to the coresponding
    #   code in the palette
    #     - search the palette using binary search
    code = colour if colour.is_a? Integer

    error = "Invalid colour definition, must be a string."
    raise error unless colour.is_a? String

    colour.strip!
    case colour[0]
    when '@'
      colour[0] = ""
      code = colour.to_i
    when '#'
      colour[0] = ""
    end

    return 82
  end

  def self.colourize_ansi(string, fg=:default, bg=:default)
    fgcc = get_colour_code(fg, nil) + 30
    bgcc = get_colour_code(bg, nil) + 40
    "\e[#{fgcc}#{string}#{CLEAR}"
  end

  def self.colourize_extended(string, fg, bg)
  end

  def self.decorate_string(string, fg=:default, bg=:default,
                           bold=False, underlined=False)
  end

  def self.use_config()
    puts bold underline "Whaat?"
  end
end
