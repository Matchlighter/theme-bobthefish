
# ==============================
# Helper methods
# ==============================

function resolve_key -S -a template -a key
  [ -n "$key" ]; or return
  set -l current_key (string replace -a "%s" "$key" "$template")
  for item in $$current_key
    echo "$item"
  end
end

function __bobthefish_basename -d 'basically basename, but faster'
  string replace -r '^.*/' '' -- $argv
end

function __bobthefish_dirname -d 'basically dirname, but faster'
  string replace -r '/[^/]+/?$' '' -- $argv
end

function __bobthefish_git_branch -S -d 'Get the current git branch (or commitish)'
  set -l ref (command git symbolic-ref HEAD 2>/dev/null); and begin
    [ "$btf_prompt_git_master_branch" != 'yes' -a "$ref" = 'refs/heads/master' ]
      and echo $branch_glyph
      and return

    string replace 'refs/heads/' "$branch_glyph " $ref
      and return
  end

  set -l tag (command git describe --tags --exact-match 2>/dev/null)
    and echo "$tag_glyph $tag"
    and return

  set -l branch (command git show-ref --head -s --abbrev | head -n1 2>/dev/null)
  echo "$detached_glyph $branch"
end

function __bobthefish_hg_branch -S -d 'Get the current hg branch'
  set -l branch (command hg branch 2>/dev/null)
  set -l book (command hg book | command grep \* | cut -d\  -f3)
  echo "$branch_glyph $branch @ $book"
end

function __bobthefish_pretty_parent -S -a current_dir -d 'Print a parent directory, shortened to fit the prompt'
  set -q fish_prompt_pwd_dir_length
    or set -l fish_prompt_pwd_dir_length 1

  # Replace $HOME with ~
  set -l real_home ~
  set -l parent_dir (string replace -r '^'"$real_home"'($|/)' '~$1' (__bobthefish_dirname $current_dir))

  # Must check whether `$parent_dir = /` if using native dirname
  if [ -z "$parent_dir" ]
    echo -n /
    return
  end

  if [ $fish_prompt_pwd_dir_length -eq 0 ]
    echo -n "$parent_dir/"
    return
  end

  string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' "$parent_dir/"
end

function __bobthefish_ignore_vcs_dir -d 'Check whether the current directory should be ignored as a VCS segment'
  for p in $btf_prompt_vcs_ignore_paths
    set ignore_path (realpath $p 2>/dev/null)
    switch $PWD/
      case $ignore_path/\*
        echo 1
        return
    end
  end
end

function __bobthefish_git_project_dir -S -d 'Print the current git project base directory'
  set -q btf_prompt_vcs_ignore_paths
    and [ (__bobthefish_ignore_vcs_dir) ]
    and return

  if [ "$btf_prompt_git_worktree_support" != 'yes' ]
    command git rev-parse --show-toplevel 2>/dev/null
    return
  end

  set -l git_dir (command git rev-parse --git-dir 2>/dev/null); or return

  pushd $git_dir
  set git_dir $PWD
  popd

  switch $PWD/
    case $git_dir/\*
      # Nothing works quite right if we're inside the git dir
      # TODO: fix the underlying issues then re-enable the stuff below

      # # if we're inside the git dir, sweet. just return that.
      # set -l toplevel (command git rev-parse --show-toplevel 2>/dev/null)
      # if [ "$toplevel" ]
      #   switch $git_dir/
      #     case $toplevel/\*
      #       echo $git_dir
      #   end
      # end
      return
  end

  set -l project_dir (__bobthefish_dirname $git_dir)

  switch $PWD/
    case $project_dir/\*
      echo $project_dir
      return
  end

  set project_dir (command git rev-parse --show-toplevel 2>/dev/null)
  switch $PWD/
    case $project_dir/\*
      echo $project_dir
  end
end

function __bobthefish_hg_project_dir -S -d 'Print the current hg project base directory'
  set -q btf_prompt_vcs_ignore_paths
    and [ (__bobthefish_ignore_vcs_dir) ]
    and return

  set -l d $PWD
  while not [ -z "$d" ]
    if [ -e $d/.hg ]
      command hg root --cwd "$d" 2>/dev/null
      return
    end
    [ "$d" = '/' ]; and return
    set d (__bobthefish_dirname $d)
  end
end

function __bobthefish_project_pwd -S -a current_dir -d 'Print the working directory relative to project root'
  set -q btf_prompt_vcs_project_dir_length
    or set -l btf_prompt_vcs_project_dir_length 0

  set -l project_dir (string replace -r '^'"$current_dir"'($|/)' '' $PWD)

  if [ $btf_prompt_vcs_project_dir_length -eq 0 ]
    echo -n $project_dir
    return
  end

  string replace -ar '(\.?[^/]{'"$btf_prompt_vcs_project_dir_length"'})[^/]*/' '$1/' $project_dir
end

function __bobthefish_git_ahead -S -d 'Print the ahead/behind state for the current branch'
  if [ "$btf_prompt_git_ahead_verbose" = 'yes' ]
    __bobthefish_git_ahead_verbose
    return
  end

  set -l ahead 0
  set -l behind 0
  for line in (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
    switch "$line"
      case '>*'
        if [ $behind -eq 1 ]
          echo '±'
          return
        end
        set ahead 1
      case '<*'
        if [ $ahead -eq 1 ]
          echo "$git_plus_minus_glyph"
          return
        end
        set behind 1
    end
  end

  if [ $ahead -eq 1 ]
    echo "$git_plus_glyph"
  else if [ $behind -eq 1 ]
    echo "$git_minus_glyph"
  end
end

function __bobthefish_git_ahead_verbose -S -d 'Print a more verbose ahead/behind state for the current branch'
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
    or return

  set -l behind (count (for arg in $commits; echo $arg; end | command grep '^<'))
  set -l ahead (count (for arg in $commits; echo $arg; end | command grep -v '^<'))

  switch "$ahead $behind"
    case '' # no upstream
    case '0 0' # equal to upstream
      return
    case '* 0' # ahead of upstream
      echo "$git_ahead_glyph$ahead"
    case '0 *' # behind upstream
      echo "$git_behind_glyph$behind"
    case '*' # diverged from upstream
      echo "$git_ahead_glyph$ahead$git_behind_glyph$behind"
  end
end

function __bobthefish_git_dirty_verbose -S -d 'Print a more verbose dirty state for the current working tree'
  set -l changes (command git diff --numstat | awk '{ added += $1; removed += $2 } END { print "+" added "/-" removed }')
    or return

  echo "$changes " | string replace -r '(\+0/(-0)?|/-0)' ''
end


# ==============================
# Segment functions
# ==============================

function __bobthefish_start_segment -S -d 'Start a prompt segment'
  set -l bg $argv[1]
  set -e argv[1]
  set -l fg $argv[1]
  set -e argv[1]

  set_default bg black
  set_default fg white

  set_color normal # clear out anything bold or underline...

  if [ "$prompt_side" = 'left' ]
    set_color -b $bg $fg $argv

    switch "$__bobthefish_current_bg"
      case ''
        # If there's no background, just start one
        echo -n ' '
      case "$bg"
        # If the background is already the same color, draw a separator
        echo -ns $right_arrow_glyph ' '
      case '*'
        # otherwise, draw the end of the previous segment and the start of the next
        set_color $__bobthefish_current_bg
        echo -ns $right_black_arrow_glyph ' '
        set_color $fg $argv
    end

  else if [ "$prompt_side" = 'right' ]
    if [ "$btf_right_colorized" = 'yes' ]
      switch "$__bobthefish_current_bg"
        case ''
          # If there's no background, just start one
          set_color $bg
          echo -ns $left_black_arrow_glyph
        case "$bg"
          # If the background is already the same color, draw a separator
          echo -ns $left_arrow_glyph
        case '*'
          # otherwise, draw the end of the previous segment and the start of the next
          set_color -b $__bobthefish_current_bg $bg
          echo -ns $left_black_arrow_glyph
      end

      set_color -b $bg $fg $argv
    else
      set_color $fish_color_autosuggestion
      if [ -n "$__bobthefish_current_bg" ]
        echo -ns $left_arrow_glyph
      end
    end
    echo ' '
  end

  set __bobthefish_current_bg $bg
end

function __bobthefish_finish_segments -S -d 'Close open prompt segments'
  if [ -n "$__bobthefish_current_bg" -a "$prompt_side" = 'left' ]
    set_color normal
    set_color $__bobthefish_current_bg
    echo -ns $right_black_arrow_glyph ' '
  end

  set_color normal
  set __bobthefish_current_bg
end

function __bobthefish_start_segment_key -S -a key -d 'Start a prompt segment for a given key name'
  set -l prompt_color (resolve_key 'btf_prompt_%s_color' "$key")
  set -q prompt_color; or set -l prompt_color $prompt_default_color
  __bobthefish_start_segment $prompt_color
end

function __bobthefish_segment_icon -S -a key
  [ -n "$key" ]; and set -l $key "$__bobthefish_segment"
  set -l icon (resolve_key "btf_prompt_%s_icon" "$key")
  [ -z "$icon" ]; and echo -ens $icon
end

function __bobthefish_prompt_segment -S -a key -a content
  [ -n "$key" ]; and set -l $key "$__bobthefish_segment"
  __bobthefish_start_segment_key $key
  __bobthefish_segment_icon $key
  echo -ens $content
end


# ==============================
# Status and input mode segments
# ==============================

function __bobthefish_prompt_status -S -d 'Display flags for a non-zero exit status, root user, and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  [ $last_status -ne 0 ]
    and set nonzero 1

  # If superuser (uid == 0)
  #
  # Note that iff the current user is root and '/' is not writeable by root this
  # will be wrong. But I can't think of a single reason that would happen, and
  # it is literally 99.5% faster to check it this way, so that's a tradeoff I'm
  # willing to make.
  [ -w / ]
    and [ (id -u) -eq 0 ]
    and set superuser 1

  # Jobs display
  jobs -p >/dev/null
    and set bg_jobs 1

  if [ "$nonzero" -o "$superuser" -o "$bg_jobs" ]
    __bobthefish_start_segment $color_initial_segment_exit
    if [ "$nonzero" ]
      set_color normal
      set_color -b $color_initial_segment_exit
      if [ "$btf_prompt_status_show_exit_status" = 'yes' ]
        echo -ns $last_status ' '
      else
        echo -n $nonzero_exit_glyph
      end
    end

    if [ "$superuser" ]
      set_color normal
      if [ -z "$FAKEROOTKEY" ]
        set_color -b $color_initial_segment_su
      else
        set_color -b $color_initial_segment_exit
      end

      echo -n $superuser_glyph
    end

    if [ "$bg_jobs" ]
      set_color normal
      set_color -b $color_initial_segment_jobs
      echo -n $bg_job_glyph
    end
  end
end

function __bobthefish_prompt_vi -S -d 'Display vi mode'
  [ "$fish_key_bindings" = 'fish_vi_key_bindings' \
    -o "$fish_key_bindings" = 'hybrid_bindings' \
    -o "$fish_key_bindings" = 'fish_hybrid_key_bindings' ]; or return
  switch $fish_bind_mode
    case default
      __bobthefish_start_segment $color_vi_mode_default
      echo -n 'N '
    case insert
      __bobthefish_start_segment $color_vi_mode_insert
      echo -n 'I '
    case replace_one replace-one
      __bobthefish_start_segment $color_vi_mode_insert
      echo -n 'R '
    case visual
      __bobthefish_start_segment $color_vi_mode_visual
      echo -n 'V '
  end
end

function __bobthefish_prompt_cmd_duration -S -d 'Show command duration'
  [ -z "$CMD_DURATION" -o "$CMD_DURATION" -lt 100 ]; and return

  __bobthefish_prompt_segment 'cmd_duration'

  if [ "$CMD_DURATION" -lt 5000 ]
    echo -ns $CMD_DURATION 'ms'
  else if [ "$CMD_DURATION" -lt 60000 ]
    __bobthefish_pretty_ms $CMD_DURATION s
  else if [ "$CMD_DURATION" -lt 3600000 ]
    set_color $fish_color_error
    __bobthefish_pretty_ms $CMD_DURATION m
  else
    set_color $fish_color_error
    __bobthefish_pretty_ms $CMD_DURATION h
  end
  echo -n ' '
end

function __bobthefish_pretty_ms -S -a ms interval -d 'Millisecond formatting for humans'
  set -l interval_ms
  set -l scale 1

  switch $interval
    case s
      set interval_ms 1000
    case m
      set interval_ms 60000
    case h
      set interval_ms 3600000
      set scale 2
  end

  switch $FISH_VERSION
    # Fish 2.3 and lower doesn't know about the -s argument to math.
    case 2.0.\* 2.1.\* 2.2.\* 2.3.\*
      math "scale=$scale;$ms/$interval_ms" | string replace -r '\\.?0*$' $interval
    case \*
      math -s$scale "$ms/$interval_ms" | string replace -r '\\.?0*$' $interval
  end
end

function __bobthefish_prompt_timestamp -S -d 'Show the current timestamp'
  set -q btf_date_format; or set -l btf_date_format "+%c"
  __bobthefish_prompt_segment 'timestamp' (date $btf_date_format)
  echo -n ' '
end

# ==============================
# Container and VM segments
# ==============================

function __bobthefish_prompt_vagrant -S -d 'Display Vagrant status'
  [ -f Vagrantfile ]; or return

  # .vagrant/machines/$machine/$provider/id
  for file in .vagrant/machines/*/*/id
    read -l id <"$file"

    if [ -n "$id" ]
      switch "$file"
        case '*/virtualbox/id'
          __bobthefish_prompt_vagrant_vbox $id
        case '*/vmware_fusion/id'
          __bobthefish_prompt_vagrant_vmware $id
        case '*/parallels/id'
          __bobthefish_prompt_vagrant_parallels $id
      end
    end
  end
end

function __bobthefish_prompt_vagrant_vbox -S -a id -d 'Display VirtualBox Vagrant status'
  set -l vagrant_status
  set -l vm_status (VBoxManage showvminfo --machinereadable $id 2>/dev/null | command grep 'VMState=' | tr -d '"' | cut -d '=' -f 2)
  switch "$vm_status"
    case 'running'
      set vagrant_status "$vagrant_status$vagrant_running_glyph"
    case 'poweroff'
      set vagrant_status "$vagrant_status$vagrant_poweroff_glyph"
    case 'aborted'
      set vagrant_status "$vagrant_status$vagrant_aborted_glyph"
    case 'saved'
      set vagrant_status "$vagrant_status$vagrant_saved_glyph"
    case 'stopping'
      set vagrant_status "$vagrant_status$vagrant_stopping_glyph"
    case ''
      set vagrant_status "$vagrant_status$vagrant_unknown_glyph"
  end
  [ -z "$vagrant_status" ]; and return

  __bobthefish_prompt_segment 'vagrant'
  echo -ns $vagrant_status ' '
end

function __bobthefish_prompt_vagrant_vmware -S -a id -d 'Display VMWare Vagrant status'
  set -l vagrant_status
  if [ (pgrep -f "$id") ]
    set vagrant_status "$vagrant_status$vagrant_running_glyph"
  else
    set vagrant_status "$vagrant_status$vagrant_poweroff_glyph"
  end
  [ -z "$vagrant_status" ]; and return

  __bobthefish_prompt_segment 'vagrant'
  echo -ns $vagrant_status ' '
end

function __bobthefish_prompt_vagrant_parallels -S -d 'Display Parallels Vagrant status'
  set -l vagrant_status
  set -l vm_status (prlctl list $id -o status 2>/dev/null | command tail -1)
  switch "$vm_status"
    case 'running'
      set vagrant_status "$vagrant_status$vagrant_running_glyph"
    case 'stopped'
      set vagrant_status "$vagrant_status$vagrant_poweroff_glyph"
    case 'paused'
      set vagrant_status "$vagrant_status$vagrant_saved_glyph"
    case 'suspended'
      set vagrant_status "$vagrant_status$vagrant_saved_glyph"
    case 'stopping'
      set vagrant_status "$vagrant_status$vagrant_stopping_glyph"
    case ''
      set vagrant_status "$vagrant_status$vagrant_unknown_glyph"
  end
  [ -z "$vagrant_status" ]; and return

  __bobthefish_prompt_segment 'vagrant'
  echo -ns $vagrant_status ' '
end

function __bobthefish_prompt_docker -S -d 'Display Docker machine name'
  [ -z "$DOCKER_MACHINE_NAME" ]; and return
  __bobthefish_prompt_segment 'vagrant'
  echo -ns $DOCKER_MACHINE_NAME ' '
end

function __bobthefish_prompt_k8s_context -S -d 'Show current Kubernetes context'
  set -l config_paths "$HOME/.kube/config"
  [ -n "$KUBECONFIG" ]
    and set config_paths (string split ':' "$KUBECONFIG") $config_paths

  for file in $config_paths
    [ -f "$file" ]; or continue

    while read -l key val
      if [ "$key" = 'current-context:' ]
        set -l context (string trim -c '"\' ' -- $val)
        [ -z "$context" ]; and return

        __bobthefish_prompt_segment 'k8s'
        echo -ns $context ' '
        return
      end
    end < $file
  end
end

function __bobthefish_prompt_vaulted -S -d 'Display current Vaulted Environment'
  [ -z "$VAULTED_ENV" ]; and return
  __bobthefish_prompt_segment 'vaulted' (echo -ns "$VAULTED_ENV" ' ')
end


# ==============================
# User / hostname info segments
# ==============================

# Polyfill for fish < 2.5.0
if not type -q prompt_hostname
  if not set -q __bobthefish_prompt_hostname
    set -g __bobthefish_prompt_hostname (hostname | string replace -r '\..*' '')
  end

  function prompt_hostname
    echo $__bobthefish_prompt_hostname
  end
end

function __bobthefish_prompt_context -S -d 'Display current user and hostname'
  [ -n "$SSH_CLIENT" -o \( -n "$default_user" -a "$USER" != "$default_user" \) ]
    and set -l display_user
  [ -n "$SSH_CLIENT" ]
    and set -l display_hostname

  if set -q display_user
    __bobthefish_prompt_segment 'username'
    echo -ns (whoami)
  end

  if set -q display_hostname
    if set -q display_user
      # reset colors without starting a new segment...
      # (so we can have a bold username and non-bold hostname)
      set_color normal
      set_color -b $btf_prompt_hostname_color[1] $btf_prompt_hostname_color[2..-1]
      echo -ns '@' (prompt_hostname)
    else
      __bobthefish_prompt_segment 'hostname'
      echo -ns (prompt_hostname)
    end
  end

  set -q display_user
    or set -q display_hostname
    and echo -ns ' '
end


# ==============================
# Virtual environment segments
# ==============================

function __bobthefish_rvm_parse_ruby -S -a ruby_string scope -d 'Parse RVM Ruby string'
  # Function arguments:
  # - 'ruby-2.2.3@rails', 'jruby-1.7.19'...
  # - 'default' or 'current'
  set -l IFS @
  echo "$ruby_string" | read __ruby __rvm_{$scope}_ruby_gemset __
  set IFS -
  echo "$__ruby" | read __rvm_{$scope}_ruby_interpreter __rvm_{$scope}_ruby_version __
  set -e __ruby
  set -e __
end

function __bobthefish_rvm_info -S -d 'Current Ruby information from RVM'
  # look for rvm install path
  set -q rvm_path
    or set -l rvm_path ~/.rvm /usr/local/rvm

  # More `sed`/`grep`/`cut` magic...
  set -l __rvm_default_ruby (grep GEM_HOME $rvm_path/environments/default 2>/dev/null | sed -e"s/'//g" | sed -e's/.*\///')
  set -l __rvm_current_ruby (rvm-prompt i v g)
  [ "$__rvm_default_ruby" = "$__rvm_current_ruby" ]; and return

  set -l __rvm_default_ruby_gemset
  set -l __rvm_default_ruby_interpreter
  set -l __rvm_default_ruby_version
  set -l __rvm_current_ruby_gemset
  set -l __rvm_current_ruby_interpreter
  set -l __rvm_current_ruby_version

  # Parse default and current Rubies to global variables
  __bobthefish_rvm_parse_ruby $__rvm_default_ruby default
  __bobthefish_rvm_parse_ruby $__rvm_current_ruby current
  # Show unobtrusive RVM prompt

  # If interpreter differs form default interpreter, show everything:
  if [ "$__rvm_default_ruby_interpreter" != "$__rvm_current_ruby_interpreter" ]
    if [ "$__rvm_current_ruby_gemset" = 'global' ]
      rvm-prompt i v
    else
      rvm-prompt i v g
    end
  # If version differs form default version
  else if [ "$__rvm_default_ruby_version" != "$__rvm_current_ruby_version" ]
    if [ "$__rvm_current_ruby_gemset" = 'global' ]
      rvm-prompt v
    else
      rvm-prompt v g
    end
  # If gemset differs form default or 'global' gemset, just show it
  else if [ "$__rvm_default_ruby_gemset" != "$__rvm_current_ruby_gemset" ]
    rvm-prompt g
  end
end

function __bobthefish_prompt_rubies -S -d 'Display current Ruby information'
  set -l ruby_version
  if type -fq rvm-prompt
    set ruby_version (__bobthefish_rvm_info)
  else if type -fq rbenv
    set ruby_version (rbenv version-name)
    # Don't show global ruby version...
    set -q RBENV_ROOT
      or set -l RBENV_ROOT $HOME/.rbenv

    [ -e "$RBENV_ROOT/version" ]
      and read -l global_ruby_version <"$RBENV_ROOT/version"

    [ "$global_ruby_version" ]
      or set -l global_ruby_version system

    [ "$ruby_version" = "$global_ruby_version" ]; and return
  else if type -q chruby # chruby is implemented as a function, so omitting the -f is intentional
    set ruby_version $RUBY_VERSION
  else if type -fq asdf
    asdf current ruby 2>/dev/null | read -l asdf_ruby_version asdf_provenance
      or return

    # If asdf changes their ruby version provenance format, update this to match
    [ "$asdf_provenance" = "(set by $HOME/.tool-versions)" ]; and return

    set ruby_version $asdf_ruby_version
  end
  [ -z "$ruby_version" ]; and return
  __bobthefish_prompt_segment 'rvm'
  echo -ns $ruby_glyph $ruby_version ' '
end

function __bobthefish_virtualenv_python_version -S -d 'Get current Python version'
  switch (python --version 2>&1 | tr '\n' ' ')
    case 'Python 2*PyPy*'
      echo $pypy_glyph
    case 'Python 3*PyPy*'
      echo -s $pypy_glyph $superscript_glyph[3]
    case 'Python 2*'
      echo $superscript_glyph[2]
    case 'Python 3*'
      echo $superscript_glyph[3]
  end
end

function __bobthefish_prompt_virtualfish -S -d "Display current Python virtual environment (only for virtualfish, virtualenv's activate.fish changes prompt by itself) or conda environment."
  [ -z "$VIRTUAL_ENV" -a -z "$CONDA_DEFAULT_ENV" ]; and return
  set -l version_glyph (__bobthefish_virtualenv_python_version)
  if [ "$version_glyph" ]
    __bobthefish_prompt_segment 'virtualfish'
    echo -ns $virtualenv_glyph $version_glyph ' '
  end
  if [ "$VIRTUAL_ENV" ]
    echo -ns (basename "$VIRTUAL_ENV") ' '
  else if [ "$CONDA_DEFAULT_ENV" ]
    echo -ns (basename "$CONDA_DEFAULT_ENV") ' '
  end
end

function __bobthefish_prompt_virtualgo -S -d 'Display current Go virtual environment'
  [ -z "$VIRTUALGO" ]; and return
  __bobthefish_prompt_segment 'virtualgo'
  echo -ns $go_glyph ' ' (basename "$VIRTUALGO") ' '
end

function __bobthefish_prompt_desk -S -d 'Display current desk environment'
  [ -z "$DESK_ENV" ]; and return
  __bobthefish_prompt_segment 'desk'
  echo -ns $desk_glyph ' ' (basename  -a -s ".fish" "$DESK_ENV") ' '
end


# ==============================
# VCS segments
# ==============================

function __bobthefish_path_segment -S -a current_dir -d 'Display a shortened form of a directory'
  set -l segment_color $color_path
  set -l segment_basename_color $color_path_basename

  if not [ -w "$current_dir" ]
    set segment_color $color_path_nowrite
    set segment_basename_color $color_path_nowrite_basename
  end

  __bobthefish_start_segment $segment_color

  set -l directory
  set -l parent

  switch "$current_dir"
    case /
      set directory '/'
    case "$HOME"
      set directory '~'
    case '*'
      set parent    (__bobthefish_pretty_parent "$current_dir")
      set directory (__bobthefish_basename "$current_dir")
  end

  echo -n $parent
  set_color -b $segment_basename_color
  echo -ns $directory ' '
end

function __bobthefish_prompt_hg -S -a current_dir -d 'Display the actual hg state'
  set -l dirty (command hg stat; or echo -n '*')

  set -l flags "$dirty"
  [ "$flags" ]
    and set flags ""

  set -l flag_colors $color_repo
  if [ "$dirty" ]
    set flag_colors $color_repo_dirty
  end

  __bobthefish_path_segment $current_dir

  __bobthefish_start_segment $flag_colors
  echo -ns $hg_glyph ' '

  __bobthefish_start_segment $flag_colors
  echo -ns (__bobthefish_hg_branch) $flags ' '
  set_color normal

  set -l project_pwd  (__bobthefish_project_pwd $current_dir)
  if [ "$project_pwd" ]
    if [ -w "$PWD" ]
      __bobthefish_start_segment $color_path
    else
      __bobthefish_start_segment $color_path_nowrite
    end

    echo -ns $project_pwd ' '
  end
end

function __bobthefish_prompt_git -S -a current_dir -d 'Display the actual git state'
  set -l dirty ''
  if [ "$btf_prompt_git_dirty" != 'no' ]
    set -l show_dirty (command git config --bool bash.showDirtyState 2>/dev/null)
    if [ "$show_dirty" != 'false' ]
      set dirty (command git diff --no-ext-diff --quiet --exit-code 2>/dev/null; or echo -n "$git_dirty_glyph")
      if [ "$dirty" -a "$btf_prompt_git_dirty_verbose" = 'yes' ]
        set dirty "$dirty"(__bobthefish_git_dirty_verbose)
      end
    end
  end

  set -l staged  (command git diff --cached --no-ext-diff --quiet --exit-code 2>/dev/null; or echo -n "$git_staged_glyph")
  set -l stashed (command git rev-parse --verify --quiet refs/stash >/dev/null; and echo -n "$git_stashed_glyph")
  set -l ahead   (__bobthefish_git_ahead)

  set -l new ''
  if [ "$btf_prompt_git_untracked" != 'no' ]
    set -l show_untracked (command git config --bool bash.showUntrackedFiles 2>/dev/null)
    if [ "$show_untracked" != 'false' ]
      set new (command git ls-files --other --exclude-standard --directory --no-empty-directory 2>/dev/null)
      if [ "$new" ]
        set new "$git_untracked_glyph"
      end
    end
  end

  set -l flags "$dirty$staged$stashed$ahead$new"
  [ "$flags" ]
    and set flags " $flags"

  set -l flag_colors $color_repo
  if [ "$dirty" ]
    set flag_colors $color_repo_dirty
  else if [ "$staged" ]
    set flag_colors $color_repo_staged
  end

  __bobthefish_path_segment $current_dir

  __bobthefish_start_segment $flag_colors
  echo -ns (__bobthefish_git_branch) $flags ' '
  set_color normal

  if [ "$btf_prompt_git_worktree_support" != 'yes' ]
    set -l project_pwd (__bobthefish_project_pwd $current_dir)
    if [ "$project_pwd" ]
      if [ -w "$PWD" ]
        __bobthefish_start_segment $color_path
      else
        __bobthefish_start_segment $color_path_nowrite
      end

      echo -ns $project_pwd ' '
    end
    return
  end

  set -l project_pwd (command git rev-parse --show-prefix 2>/dev/null | string trim --right --chars=/)
  set -l work_dir (command git rev-parse --show-toplevel 2>/dev/null)

  # only show work dir if it's a parent…
  if [ "$work_dir" ]
    switch $PWD/
      case $work_dir/\*
        string match "$current_dir*" $work_dir >/dev/null
          and set work_dir (string sub -s (math 1 + (string length $current_dir)) $work_dir)
      case \*
        set -e work_dir
    end
  end

  if [ "$project_pwd" -o "$work_dir" ]
    set -l colors $color_path
    if not [ -w "$PWD" ]
      set colors $color_path_nowrite
    end

    __bobthefish_start_segment $colors

    # handle work_dir != project dir
    if [ "$work_dir" ]
      set -l work_parent (__bobthefish_dirname $work_dir)
      if [ "$work_parent" ]
        echo -n "$work_parent/"
      end
      set_color normal
      set_color -b $color_repo_work_tree
      echo -n (__bobthefish_basename $work_dir)
      set_color normal
      set_color -b $colors
      [ "$project_pwd" ]
        and echo -n '/'
    end

    echo -ns $project_pwd ' '
  else
    set project_pwd $PWD
    string match "$current_dir*" $project_pwd >/dev/null
      and set project_pwd (string sub -s (math 1 + (string length $current_dir)) $project_pwd)
    set project_pwd (string trim --left --chars=/ -- $project_pwd)

    if [ "$project_pwd" ]
      set -l colors $color_path
      if not [ -w "$PWD" ]
        set colors $color_path_nowrite
      end

      __bobthefish_start_segment $colors

      echo -ns $project_pwd ' '
    end
  end
end

function __bobthefish_prompt_dir -S -d 'Display a shortened form of the current directory'
  __bobthefish_path_segment "$PWD"
end

function __bobthefish_prompt_vcs -S -d 'Display VCS State'
  set -l git_root (__bobthefish_git_project_dir)
  set -l hg_root  (__bobthefish_hg_project_dir)

  if [ "$git_root" -a "$hg_root" ]
    # only show the closest parent
    switch $git_root
      case $hg_root\*
        __bobthefish_prompt_git $git_root
      case \*
        __bobthefish_prompt_hg $hg_root
    end
  else if [ "$git_root" ]
    __bobthefish_prompt_git $git_root
  else if [ "$hg_root" ]
    __bobthefish_prompt_hg $hg_root
  else
    __bobthefish_prompt_dir
  end
end

# ==============================
# Misc segments
# ==============================

function __bobthefish_prompt_newline -S
  # Ignore newlines on the right side
  if [ $prompt_side = 'left' ]
    __bobthefish_finish_segments
    echo -ens "\n" $btf_prompt_newline_prefix
    set -g __bobthefish_newlines (math -- $__bobthefish_newlines + 1)
  end
end


# ==============================
# Custom prompt segments
# ==============================

function __bobthefish_prompt_custom -S -a name -d 'Prepare a custom prompt segment'

end


# ==============================
# Apply theme
# ==============================

function __bobthefish_prompt -S -d 'Render sections of a prompt'
  __bobthefish_glyphs
  __bobthefish_colors $btf_color_scheme
  type -q bobthefish_colors
    and bobthefish_colors

  # Start each line with a blank slate
  set -g __bobthefish_newlines 0
  set -l __bobthefish_current_bg

  for element in $argv
    set -l __bobthefish_segment "$element"
    if [ (string sub -l 7 $element) = "custom_" ]
      __bobthefish_prompt_custom (string sub -s 8 $element)
    else
      eval "__bobthefish_prompt_$element"
    end
  end

  __bobthefish_finish_segments
end