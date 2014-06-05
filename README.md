# tco - terminal colours made simple

[![Gem Version](https://badge.fury.io/rb/tco.png)](http://badge.fury.io/rb/tco)
[![Inline docs](http://inch-ci.org/github/pazdera/tco.png)](http://inch-ci.org/github/pazdera/tco)
[![Build Status][BS img]][Build Status]
[Build Status]: https://travis-ci.org/pazdera/tco
[BS img]: https://travis-ci.org/pazdera/tco.png

The purpose of the **tco** gem is to make colouring in the terminal as
convenient and as simple as possible. It provides a library for your Ruby gems
and also a standalone command line tool that you can use anywhere else.

## Introduction

If you've ever worked with the **extended colour palette** in the terminal, you
probably know that it's not really easy to find the colour you want. The
palette consists of 256 colours that are evenly sampled through the RGB space.
As opposed to the **ANSI palette**, the colours tend to be the same across
different terminals. They are assigned linearly to a set of escape sequences
that are used to apply the colours. And that is the problem; searching
through the palette is very unintuitive.

On the other hand, selecting a RGB colour using your favourite
[colour picker](http://www.colourpicker.com/) is a nice, buttery piece of cake
with a bit of cream on top. That is everything you need to do; pass the value
to `tco` and it will sort out all the boring bits for you. Using the
RGB value, the library will find the **perceptually closest** option that is
displayable in your terminal and decorate the string with the appropriate
escape sequences, letting you focus on more interesting things in life instead.

On top of that, it comes with a simple built-in templating engine that you can
use to decorate only the parts that you want without having to split your
string into 15 parts. Check out the following examples.

### A few examples

The `tco` terminal utility allows you to do the simple things you might need
in your bash scripts:

[![Using tco to colour text](http://broken.build/assets/images/posts/tco-terminal.png)](http://broken.build/assets/images/posts/tco-terminal.png)

However, using `tco` directly from Ruby gives you much more flexibility. The
following short piece of code will draw a rainbow inside your terminal:

```ruby
require "tco"

rainbow = ["#622e90", "#2d3091", "#00aaea", "#02a552", "#fdea22", "#eb443b", "#f37f5a"]
10.times do
  rainbow.each { |colour| print "    ".bg colour }
  puts
end
```

[![tco showing a simple rainbow](http://broken.build/assets/images/posts/tco-rainbow.png)](http://broken.build/assets/images/posts/tco-rainbow.png)

And if you add a bit of `rmagick` to the equation, you can even render whole
images in your terminal with no more than 10 lines of code.

```ruby
require "tco"
require "rmagick"

Magick::Image.read("tux.png")[0].each_pixel do |pixel, col, row|
  c = [pixel.red, pixel.green, pixel.blue].map { |v| 255*(v/65535.0) }
  print "  ".bg c
  puts if col >= 53
end
```

[![Tux drawn with tco](http://broken.build/assets/images/posts/tco-tux.png)](http://broken.build/assets/images/posts/tco-tux.png)

These were just the basic things you can do with `tco`. There are many more
options and features available, many of them are described in the **Usage**
section just bellow.

## Usage

You can use either the `tco` binary for your command line applications or the
library directly from your Ruby scripts. Both use cases are explained bellow.

### The Ruby library

When it comes to colouring, there are two options available. You can either use
the default library interface, or use the `String` extension that also comes
with the library. Both of them offer exactly the same functionality (`fg`, `bg`,
`bright`, `underline`). See the example of both, below:

```ruby
require "tco"

# The standard interface
puts Tco::fg("#ff0000", Tco::bg("#888888", Tco::bright("London")))
puts Tco::underline "Underground"

# The String object extension
puts "London".fg("#ff0000").bg("#888888").bright
puts "Underground".underline

# Using predefined style
puts "London".style "alert"
puts Tco::style "alert", "Underground"
```

In the last bit of the example above, I'm referring to a preconfigured style
definition. You can set them either system-wide in `/etc/tco.conf` or just for
a single user in the `~/.tco.conf` file. They both are just simple YAML files.
The precise format of these configuration files is explained at the end of this
file.

#### Changing the configuration on the fly

A notable feature in regards of configuration is the fact, that you can easily
change it on-the-fly. This can be useful for adding aliases for colours and
defining your own styles just for your application, so you don't have to repeat
the same settings all over your script. All these settings will be applied on
top of the user and system config files.

```ruby
require "tco"

Tco::configure do |tco_conf|
  tco_conf.names["white"] = "#000"
  tco_conf.styles["pass"] = {
    "fg" => "#000",
    "bg" => "#00ff00",
    "bright" => false,
    "underline" => false,
  }
end
```

Apart from that, the library then contains a few more advanced things which
aren't that useful for everyone. Please, have a look at `lib/tco/tco.rb` if
you're interested.

### The command-line tool

Using the `tco` command is just as simple as using the Ruby library. It expects
input either as a positional argument or alternatively at the standard input.

Apart from the core functionality, the CLI tool adds support for simple
templates that let you markup certain parts of your string. All templates
are enclosed in double curly brackets `{{fg:bg:ub text}}`. Check out the
following examples:

```bash
tco -f "#c0ffee" -b "white" "Some input text"
tco -b "grey" -B "Some input text"

tco "{{alert ERROR:}} The {{::b download}} has failed."
echo "{{#000:#ffffff black on white}}" | tco
```

For the full list of options, please refer to the help of the `tco` command.

### Specifying colours

With both the Ruby library and the command line tool, there is a number of
ways how to specify the colour you would like:

* **RGB** - you can do either `#c0ffee` or `0xc0ffee`
* **name** - e.g., `black` or `white`, you can assign names to colours in your
  configuration file
* **index** - you can also refer to colours through an index to the palette,
  e.g., `@0` or `@176`.


## Configuration

There are two places, where you can store your configuration:

* `/etc/tco.conf` - the system-wide configuration file
* `~/.tco.conf` - user configuration file (takes precedence)

Both of them are simple YAML text files. Pick the first one if you would like
to apply your settings system-wide, go with the second option to set things up
for yourself only (recommended).

And now the important bit, in order to make **tco** work best in your
environment, it is recommended to configure your **ANSI palette**. These 16
colours are configurable in most terminals (you probably have yours customised
too). **tco** needs to know your setup, so it can make decisions which colour
to use. If you don't configure them, tco will not use the ANSI colours at all
in order to avoid mistakes. You can do so like this:

```yaml
# Don't forget changing the values to match your terminal configuration
colour_values:
    "@0": "#3b3b3b"
    "@1": "#cf6a4c"
    "@2": "#99ad6a"
    "@3": "#d8ad4c"
    "@4": "#597bc5"
    "@5": "#a037b0"
    "@6": "#71b9f8"
    "@7": "#adadad"

    "@8": "#555555"
    "@9": "#ff5555"
    "@10": "#55ff55"
    "@11": "#ffff55"
    "@12": "#5555ff"
    "@13": "#ff55ff"
    "@14": "#55ffff"
    "@15": "#ffffff"
```

Apart from that you can also create **aliases** for colours and define
short-cut styles for configurations you tend to use often. A typical
configuration file would look like this:

```yaml
# This is unnecessary (extended palette is enabled by default).
# However, you can set this to ansi if you use an older terminal.
options:
    palette: "extended"

colour_values:
    "@0": "#3b3b3b"
    "@1": "#cf6a4c"
    "@2": "#99ad6a"
    "@3": "#d8ad4c"
    # and so on ...

names:
    black: "#000"
    red: "@1"

styles:
    error:
        fg: "black"
        bg: "red"
        bright: "true"
        underline: "false"
```

## Contributing

1. Fork it ( http://github.com/pazdera/tco/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
