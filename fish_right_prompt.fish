
function fish_right_prompt -d 'bobthefish is all about the right prompt'
  set -l __bobthefish_left_arrow_glyph \uE0B3
  if [ "$btf_powerline_fonts" = "no" ]
    set __bobthefish_left_arrow_glyph '<'
  end

  set_color $fish_color_autosuggestion

  set -l line_offset $__bobthefish_newlines # (math -- $__bobthefish_newlines / 2)
  set -l prompt_side 'right'

  repeat $line_offset echo -en "\e[1A"

  set -l btf_right_prompts cmd_duration timestamp
  __bobthefish_prompt $btf_right_prompts

  repeat $line_offset echo -en "\e[1B"
end
