# You can override some default right prompt options in your config.fish:
#     set -g theme_date_format "+%a %H:%M"

function fish_right_prompt -d 'bobthefish is all about the right prompt'
  set -l __bobthefish_left_arrow_glyph \uE0B3
  if [ "$theme_powerline_fonts" = "no" ]
    set __bobthefish_left_arrow_glyph '<'
  end

  set_color $fish_color_autosuggestion

  echo -en "\e[1A"

  set -l prompt_side 'right'

  set -l theme_right_prompts cmd_duration timestamp
  __bobthefish_prompt $theme_right_prompts

  echo -en "\e[1B"
end
