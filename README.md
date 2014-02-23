# tco - terminal colours made simple

[![Gem Version](https://badge.fury.io/rb/tco.png)](http://badge.fury.io/rb/tco)

The purpose of the **tco** gem is to make colouring in terminal as simple as
possible. It provides a library for your Ruby gems and apps, and also a
standalone command line tool that you can use anywhere else.

It supports the xterm extended 265-colour palette. However, the most important
feature is that you don't need to remember any colour codes and escape
sequences, nor to search through any palettes to get the colours you want. The
library works with **RGB values** and it will find and use the visually closest
option from the colours supported by your terminal.

On top of that, it comes with a simple built-in templating engine that you can
use to decorate only the parts that you want without having to split your
string into 15 parts. Check out the following examples:

```
$ echo "{{black:red ERROR}}  Something went terribly wrong" | tco
```

For more information on usage, please refer to the **Usage** section of this
file bellow.

## Installation

Add this line to your application's Gemfile:

    gem 'tco'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tco

## Configuration

There are a few things you'll need to configure to make **tco** work correctly
in your environment. There are two places, where you can do so:

* `/etc/tco.conf` - system-wide configuration file
* `~/.tco.conf` - user configuration file (takes precedence)

Both of them are simple YAML text files. Pick the first one if you would like
to apply your settings system-wide, go with the second option to set things up
for yourself only (recommended).

```
palette: "extended"

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

## Usage

You can use either the `tco` binary for your command line applications or the
library directly from your Ruby scripts. Both use cases are explained bellow.

### The Ruby library
- string interface
- library interface
- configuration

### The command-line tool



## Contributing

1. Fork it ( http://github.com/pazdera/word_wrap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
