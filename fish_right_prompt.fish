
function echo_n
  set -l n $argv[1]
  set -e argv[1]
  for i in (seq 0 $n)
    [ "$i" = '0' ]; and continue
    echo $argv
  end
end

function fish_right_prompt -d 'bobthefish is all about the right prompt'
  set -l __bobthefish_left_arrow_glyph \uE0B3
  if [ "$btf_powerline_fonts" = "no" ]
    set __bobthefish_left_arrow_glyph '<'
  end

  set_color $fish_color_autosuggestion

  set -l line_offset $__bobthefish_newlines # (math -- $__bobthefish_newlines / 2)
  set -l prompt_side 'right'

  echo_n $line_offset -en "\e[1A"

  set -l btf_right_prompts cmd_duration timestamp
  __bobthefish_prompt $btf_right_prompts

  echo_n $line_offset -en "\e[1B"
end
