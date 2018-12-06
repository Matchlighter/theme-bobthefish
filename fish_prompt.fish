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
# enable nerd fonts support with `set -g theme_nerd_fonts yes`):
#
#     https://github.com/ryanoasis/nerd-fonts
#
# You can override some default prompt options in your config.fish:
#
#     set -g theme_display_git_dirty no
#     set -g theme_display_git_untracked no
#     set -g theme_display_git_ahead_verbose yes
#     set -g theme_display_git_dirty_verbose yes
#     set -g theme_display_git_master_branch yes
#     set -g theme_git_worktree_support yes
#     set -g theme_display_user ssh
#     set -g theme_display_hostname ssh
#     set -g theme_avoid_ambiguous_glyphs yes
#     set -g theme_powerline_fonts no
#     set -g theme_nerd_fonts yes
#     set -g theme_show_exit_status yes
#     set -g default_user your_normal_user
#     set -g theme_color_scheme dark
#     set -g fish_prompt_pwd_dir_length 0
#     set -g theme_project_dir_length 1
#     set -g btf_newline_prompt '$ '
#     set -g theme_date_format "+%a %H:%M"

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
