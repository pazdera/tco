require "tco/style"

module Utils
  def get_params(base_style=nil, fg=nil, bg=nil, bright=false, underline=false)
    {
      :base_style => base_style,
      :fg => fg,
      :bg => bg,
      :bright => bright,
      :underline => underline
    }
  end
end
