
function fish_right_prompt -d 'bobthefish is all about the right prompt'
  set -q btf_right_prompts; or set -l btf_right_prompts cmd_duration timestamp
  set -l prompt_side 'right'
  set -l line_offset $__bobthefish_newlines # (math -- $__bobthefish_newlines / 2)

  repeat $line_offset echo -en "\e[1A"
  __bobthefish_prompt $btf_right_prompts
  repeat $line_offset echo -en "\e[1B"
end
