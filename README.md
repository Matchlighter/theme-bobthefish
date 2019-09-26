# bobthefish

`bobthefish` is a Powerline-style, Git-aware [fish][fish] theme optimized for awesome.

[![Oh My Fish](https://img.shields.io/badge/Framework-Oh_My_Fish-blue.svg?style=flat)](https://github.com/oh-my-fish/oh-my-fish) [![MIT License](https://img.shields.io/github/license/oh-my-fish/theme-bobthefish.svg?style=flat)](/LICENSE.md)

![bobthefish][screencast]


### Installation

Be sure to have Oh My Fish installed. Then just:

    omf install bobthefish

You will need a [Powerline-patched font][patching] for this to work, unless you enable the compatibility fallback option:

    set -g btf_powerline_fonts no

[I recommend picking one of these][fonts]. For more advanced awesome, install a [nerd fonts patched font][nerd-fonts], and enable nerd fonts support:

    set -g btf_nerd_fonts yes

This theme is based loosely on [agnoster][agnoster].


### Features

 * A helpful, but not too distracting, greeting.
 * A subtle timestamp hanging out off to the right.
 * Powerline-style visual hotness.
 * More colors than you know what to do with.
 * An abbreviated path which doesn't abbreviate the name of the current project.
 * All the things you need to know about Git in a glance.
 * Visual indication that you can't write to the current directory.


### The Prompt

 * Flags:
     * Previous command failed (**`!`**)
     * Background jobs (**`%`**)
     * You currently have superpowers (**`$`**)
     * Cursor on newline
 * Current vi mode
 * `User@Host` (unless you're the default user)
 * Current RVM, rbenv or chruby (Ruby) version
 * Current virtualenv (Python) version
     * _If you use virtualenv, you will probably need to disable the default virtualenv prompt, since it doesn't play nice with fish: `set -x VIRTUAL_ENV_DISABLE_PROMPT 1`_
 * Abbreviated parent directory
 * Current directory, or Git or Mercurial project name
 * Current project's repo branch (<img width="16" alt="branch-glyph" src="https://cloud.githubusercontent.com/assets/53660/8768360/53ee9b58-2e32-11e5-9977-cee0063936fa.png"> master) or detached head (`➦` d0dfd9b)
 * Git or Mercurial status, via colors and flags:
     * Dirty working directory (**`*`**)
     * Untracked files (**`…`**)
     * Staged changes (**`~`**)
     * Stashed changes (**`$`**)
     * Unpulled commits (**`-`**)
     * Unpushed commits (**`+`**)
     * Unpulled _and_ unpushed commits (**`±`**)
     * _Note that not all of these have been implemented for hg yet :)_
 * Abbreviated project-relative path


### Configuration

You can override some of the following default options in your `config.fish`:

```fish

set -g btf_title_display_process yes
set -g btf_title_display_path no
set -g btf_title_display_user yes
set -g btf_title_use_abbreviated_path no
set -g btf_date_format "+%a %H:%M"
set -g btf_avoid_ambiguous_glyphs yes
set -g btf_powerline_fonts no
set -g btf_nerd_fonts yes
set -g btf_prompt_status_show_exit_status yes
set -g default_user your_normal_user
set -g btf_color_scheme dark
set -g fish_prompt_pwd_dir_length 0
set -g btf_prompt_vcs_project_dir_length 1
set -g btf_newline_prompt '$ '
```

**Title options**

- `btf_title_display_process` - By default theme doesn't show current process name in terminal title. If you want to show it, just set to `yes`.
- `btf_title_display_path` - Use `no` to hide current working directory from title.
- `btf_title_display_user` - Set to `yes` to show the current user in the tab title (unless you're the default user).
- `btf_title_use_abbreviated_path` - Default is `yes`. This means your home directory will be displayed as `~` and `/usr/local` as `/u/local`. Set it to `no` if you prefer full paths in title.

**Prompt options**

- `btf_left_prompts` - Define the prompt segments that will appear in the left prompt.
- `btf_right_prompts` - Define the prompt segments that will appear in the right prompt.
- `btf_right_colorized` - Set to `yes` to enable colorized segments of the right prompt.
- `btf_newline_prompt` - Use a custom prompt with newline cursor. By default this is the chevron right glyph or `>` when powerline fonts are disabled.
- `btf_date_format` - Use a custom format when printing dates.
- `fish_prompt_pwd_dir_length` - bobthefish respects the Fish `$fish_prompt_pwd_dir_length` setting to abbreviate the prompt path. Set to `0` to show the full path, `1` (default) to show only the first character of each parent directory name, or any other number to show up to that many characters.

**Color scheme options**

| ![dark][dark]           | ![light][light]                     |
|-------------------------|-------------------------------------|
| ![solarized][solarized] | ![solarized-light][solarized-light] |
| ![base16][base16]       | ![base16-light][base16-light]       |
| ![zenburn][zenburn]     | ![terminal-dark][terminal-dark]     |

You can use the function `bobthefish_display_colors` to preview the prompts in
any color scheme.

Set `btf_color_scheme` in a terminal session or in your fish startup files to
one of the following options to change the prompt colors.

- `dark` - The default bobthefish theme.
- `light` - A lighter version of the default theme.
- `solarized` (or `solarized-dark`), `solarized-light` - Dark and light variants
  of Solarized.
- `base16` (or `base16-dark`), `base16-light` - Dark and light variants of the
  default Base16 theme.
- `zenburn` - An adaptation of Zenburn.
- `gruvbox` - An adaptation of gruvbox.
- `dracula` - An adaptation of dracula.

Some of these may not look right if your terminal does not support 24 bit color,
in which case you can try one of the `terminal` schemes (below). However, if
you're using Solarized, Base16 (default), or Zenburn in your terminal and the
terminal *does* support 24 bit color, the built in schemes will look nicer.

There are several scheme that use whichever colors you currently have loaded
into your terminal. The advantage of using the schemes that fall through to the
terminal colors is that they automatically adapt to something acceptable
whenever you change the 16 colors in your terminal profile.
- `terminal` (or `terminal-dark` or `terminal-dark-black`)
- `terminal-dark-white` - Same as `terminal`, but use white as the foreground
  color on top of colored segments (in case your colors are very dark).
- `terminal-light` (or `terminal-light-white`)
- `terminal-light-black` - Same as `terminal-light`, but use black as the
  foreground color on top of colored segments (in case your colors are very
  bright).

For some terminal themes, like dark base16 themes, the path segments in the
prompt will be indistinguishable from the background. In those cases, try one of
the following variations; they are identical to the `terminal` schemes except
for using bright black (`brgrey`) and dull white (`grey`) in the place of black
and bright white.
- `terminal2` (or `terminal2-dark` or `terminal2-dark-black`)
- `terminal2-dark-white`
- `terminal2-light` (or `terminal2-light-white`)
- `terminal2-light-black`

Finally, you can specify your very own color scheme by setting
`btf_color_scheme` to `user`. In that case, you also need to define some
variables to set the colors of the prompt. See the "Colors" section of
`fish_prompt.fish` for details.


### Prompts

**VCS (VCS/Git/Hg)**
- `btf_prompt_vcs_ignore_paths /some/path /some/other/path{foo,bar}` - Ignore project paths for Git or Mercurial. Supports glob patterns.
- `btf_prompt_vcs_project_dir_length` - The same as `$fish_prompt_pwd_dir_length`, but for the path relative to the current project root. Defaults to `0`; set to any other number to show an abbreviated path.
- `btf_prompt_git_worktree_support` - If you do any git worktree shenanigans, setting this to `yes` will fix incorrect project-relative path display. If you don't do any git worktree shenanigans, leave it disabled. It's faster this way :)
- `btf_prompt_git_dirty` (default `yes`) - 
- `btf_prompt_git_untracked` (default `yes`) - 
- `btf_prompt_git_ahead_verbose` (default `no`) - 
- `btf_prompt_git_dirty_verbose` (default `no`) - 
- `btf_prompt_git_master_branch` (default `no`) - 
- `btf_prompt_git_worktree_support` (default `no`) - 


**status**

- `btf_prompt_status_show_exit_status` - Set this option to `yes` to have the prompt show the last exit code if it was non_zero instead of just the exclamation mark.


**ruby**

Displays information about the current Ruby version


**vagrant** *(disabled by default)*

Display information about the Vagrant status of the current project.  
Please note that only the VirtualBox and VMWare providers are supported.


**vi**

Display a vi mode indicator if vi or hybrid key bindings are enabled.
- `btf_prompt_vi_always` - Set to `yes` to always show this segment.


**k8s_context** *(disabled by default)*

Shows the current kubernetes context (`> kubectl config current-context`).


**user**

If set to `yes`, display username always, if set to `ssh`, only when an SSH-Session is detected, if set to `no`, never.


**hostname**

Same behaviour as `theme_display`.


### Overrides

You can disable the theme default greeting, vi mode prompt, right prompt, or title entirely — or override with your own — by adding custom functions to `~/.config/fish/functions`:

- `~/.config/fish/functions/fish_greeting.fish`
- `~/.config/fish/functions/fish_mode_prompt.fish`
- `~/.config/fish/functions/fish_right_prompt.fish`
- `~/.config/fish/functions/fish_title.fish`

To disable them completely, use an empty function:

```fish
function fish_right_prompt; end
```

… Or copy one from your favorite theme, make up something of your own, or copy/paste a bobthefish default function and modify it to your taste!

```fish
function fish_greeting
  set_color $fish_color_autosuggestion
  echo "I'm completely operational, and all my circuits are functioning perfectly."
  set_color normal
end
```


[fish]:       https://github.com/fish-shell/fish-shell
[screencast]: https://cloud.githubusercontent.com/assets/53660/18028510/f16f6b2c-6c35-11e6-8eb9-9f23ea3cce2e.gif
[patching]:   https://powerline.readthedocs.org/en/master/installation.html#patched-fonts
[fonts]:      https://github.com/Lokaltog/powerline-fonts
[nerd-fonts]: https://github.com/ryanoasis/nerd-fonts
[agnoster]:   https://gist.github.com/agnoster/3712874

[dark]:            https://cloud.githubusercontent.com/assets/53660/16141569/ee2bbe4a-3411-11e6-85dc-3d9b0226e833.png "dark"
[light]:           https://cloud.githubusercontent.com/assets/53660/16141570/f106afc6-3411-11e6-877d-fc2a8f6d3175.png "light"
[solarized]:       https://cloud.githubusercontent.com/assets/53660/16141572/f7724032-3411-11e6-8771-b43769e7afec.png "solarized"
[solarized-light]: https://cloud.githubusercontent.com/assets/53660/16141575/fbed8036-3411-11e6-92e9-90da6d45f94b.png "solarized-light"
[base16]:          https://cloud.githubusercontent.com/assets/53660/16141577/0134763a-3412-11e6-9cca-6040d39c8fd4.png "base16"
[base16-light]:    https://cloud.githubusercontent.com/assets/53660/16141579/02f7245e-3412-11e6-97c6-5f3cecffb73c.png "base16-light"
[zenburn]:         https://cloud.githubusercontent.com/assets/53660/16141580/06229dd4-3412-11e6-84aa-a48de127b6da.png "zenburn"
[terminal-dark]:   https://cloud.githubusercontent.com/assets/53660/16141583/0b3e8eea-3412-11e6-8068-617c5371f6ea.png "terminal-dark"
