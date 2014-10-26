require "tco/style"

module Utils
  def get_params(base_style=nil, fg=nil, bg=nil, bright=nil, underline=nil)
    {
      :base_style => base_style,
      :fg => fg,
      :bg => bg,
      :bright => bright,
      :underline => underline
    }
  end
end
