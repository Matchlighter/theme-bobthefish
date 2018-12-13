# name: bobthefish
#
# bobthefish is a Powerline-style, Git-aware fish theme optimized for awesome.
#
# You will need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/master/installation.html#patched-fonts
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# For more advanced awesome, install a nerd fonts patched font (and be sure to
# enable nerd fonts support with `set -g btf_nerd_fonts yes`):
#
#     https://github.com/ryanoasis/nerd-fonts

function __bobthefish_draw_prompt -S
  if [ "$btf_left_prompts[-1]" = 'newline' ]
    set_color $fish_color_autosuggestion
    if [ "$btf_newline_prompt" != '' ]
      set prompt "$btf_newline_prompt"
    else if [ "$btf_powerline_fonts" = "no" ]
      set prompt '> '
    else
      set prompt "$right_arrow_glyph "
    end
    echo -ens "$prompt"
  end

  set_color normal
end

function fish_prompt -d 'bobthefish, a fish theme optimized for awesome'
  # Save the last status for later (do this before the `set` calls below)
  set -g last_status $status
  set -l prompt_side 'left'

  set -l btf_left_prompts status vi vagrant docker k8s_context vaulted context desk rubies virtualfish virtualgo vcs newline
  __bobthefish_prompt $btf_left_prompts

  __bobthefish_draw_prompt
end
