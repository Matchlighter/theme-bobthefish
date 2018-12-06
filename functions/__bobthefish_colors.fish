# To define a custom color scheme, create a 'bobthefish_colors' function:
# function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'
#   # optionally include a base color scheme...
#   ___bobthefish_colors default

#   # then override everything you want! note that these must be defined with `set -x`
#   set -x color_initial_segment_exit  $__color_initial_segment_exit
#   set -x color_initial_segment_su    $__color_initial_segment_su
#   set -x color_initial_segment_jobs  $__color_initial_segment_jobs
#   set -x color_path                  $__color_path
#   set -x color_path_basename         $__color_path_basename
#   set -x color_path_nowrite          $__color_path_nowrite
#   set -x color_path_nowrite_basename $__color_path_nowrite_basename
#   set -x color_repo                  $__color_repo
#   set -x color_repo_work_tree        $__color_repo_work_tree
#   set -x color_repo_dirty            $__color_repo_dirty
#   set -x color_repo_staged           $__color_repo_staged
#   set -x color_vi_mode_default       $__color_vi_mode_default
#   set -x color_vi_mode_insert        $__color_vi_mode_insert
#   set -x color_vi_mode_visual        $__color_vi_mode_visual
#   set -x btf_prompt_vagrant_color               $__color_vagrant
#   set -x btf_prompt_username_color              $__color_username
#   set -x btf_prompt_hostname_color              $__color_hostname
#   set -x btf_prompt_rvm_color                   $__color_rvm
#   set -x btf_prompt_virtualfish_color           $__color_virtualfish
#   set -x btf_prompt_virtualgo_color             $__color_virtualgo
#   set -x btf_prompt_desk_color                  $__color_desk
# end

function __bobthefish_colors -S -a color_scheme -d 'Define colors used by bobthefish'
  switch "$color_scheme"
    case 'terminal' 'terminal-dark*'
      set -l colorfg black
      [ "$color_scheme" = 'terminal-dark-white' ]; and set colorfg white
      set -x color_initial_segment_exit     white red --bold
      set -x color_initial_segment_su       white green --bold
      set -x color_initial_segment_jobs     white blue --bold

      set -x color_path                     black white
      set -x color_path_basename            black white --bold
      set -x color_path_nowrite             magenta $colorfg
      set -x color_path_nowrite_basename    magenta $colorfg --bold

      set -x color_repo                     green $colorfg
      set -x color_repo_work_tree           black $colorfg --bold
      set -x color_repo_dirty               brred $colorfg
      set -x color_repo_staged              yellow $colorfg

      set -x color_vi_mode_default          brblue $colorfg --bold
      set -x color_vi_mode_insert           brgreen $colorfg --bold
      set -x color_vi_mode_visual           bryellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  brcyan $colorfg
      set -x btf_prompt_k8s_color                      magenta white --bold
      set -x btf_prompt_username_color                 white black --bold
      set -x btf_prompt_hostname_color                 white black
      set -x btf_prompt_rvm_color                      brmagenta $colorfg --bold
      set -x btf_prompt_virtualfish_color              brblue $colorfg --bold
      set -x btf_prompt_virtualgo_color                brblue $colorfg --bold
      set -x btf_prompt_desk_color                     brblue $colorfg --bold

    case 'terminal-light*'
      set -l colorfg white
      [ "$color_scheme" = 'terminal-light-black' ]; and set colorfg black
      set -x color_initial_segment_exit     black red --bold
      set -x color_initial_segment_su       black green --bold
      set -x color_initial_segment_jobs     black blue --bold

      set -x color_path                     white black
      set -x color_path_basename            white black --bold
      set -x color_path_nowrite             magenta $colorfg
      set -x color_path_nowrite_basename    magenta $colorfg --bold

      set -x color_repo                     green $colorfg
      set -x color_repo_work_tree           white $colorfg --bold
      set -x color_repo_dirty               brred $colorfg
      set -x color_repo_staged              yellow $colorfg

      set -x color_vi_mode_default          brblue $colorfg --bold
      set -x color_vi_mode_insert           brgreen $colorfg --bold
      set -x color_vi_mode_visual           bryellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  brcyan $colorfg
      set -x btf_prompt_k8s_color                      magenta white --bold
      set -x btf_prompt_username_color                 black white --bold
      set -x btf_prompt_hostname_color                 black white
      set -x btf_prompt_rvm_color                      brmagenta $colorfg --bold
      set -x btf_prompt_virtualfish_color              brblue $colorfg --bold
      set -x btf_prompt_virtualgo_color                brblue $colorfg --bold
      set -x btf_prompt_desk_color                     brblue $colorfg --bold

    case 'terminal2' 'terminal2-dark*'
      set -l colorfg black
      [ "$color_scheme" = 'terminal2-dark-white' ]; and set colorfg white
      set -x color_initial_segment_exit     grey red --bold
      set -x color_initial_segment_su       grey green --bold
      set -x color_initial_segment_jobs     grey blue --bold

      set -x color_path                     brgrey white
      set -x color_path_basename            brgrey white --bold
      set -x color_path_nowrite             magenta $colorfg
      set -x color_path_nowrite_basename    magenta $colorfg --bold

      set -x color_repo                     green $colorfg
      set -x color_repo_work_tree           brgrey $colorfg --bold
      set -x color_repo_dirty               brred $colorfg
      set -x color_repo_staged              yellow $colorfg

      set -x color_vi_mode_default          brblue $colorfg --bold
      set -x color_vi_mode_insert           brgreen $colorfg --bold
      set -x color_vi_mode_visual           bryellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  brcyan $colorfg
      set -x btf_prompt_k8s_color                      magenta white --bold
      set -x btf_prompt_username_color                 brgrey white --bold
      set -x btf_prompt_hostname_color                 brgrey white
      set -x btf_prompt_rvm_color                      brmagenta $colorfg --bold
      set -x btf_prompt_virtualfish_color              brblue $colorfg --bold
      set -x btf_prompt_virtualgo_color                brblue $colorfg --bold
      set -x btf_prompt_desk_color                     brblue $colorfg --bold

    case 'terminal2-light*'
      set -l colorfg white
      [ "$color_scheme" = 'terminal2-light-black' ]; and set colorfg black
      set -x color_initial_segment_exit     brgrey red --bold
      set -x color_initial_segment_su       brgrey green --bold
      set -x color_initial_segment_jobs     brgrey blue --bold

      set -x color_path                     grey black
      set -x color_path_basename            grey black --bold
      set -x color_path_nowrite             magenta $colorfg
      set -x color_path_nowrite_basename    magenta $colorfg --bold

      set -x color_repo                     green $colorfg
      set -x color_repo_work_tree           grey $colorfg --bold
      set -x color_repo_dirty               brred $colorfg
      set -x color_repo_staged              yellow $colorfg

      set -x color_vi_mode_default          brblue $colorfg --bold
      set -x color_vi_mode_insert           brgreen $colorfg --bold
      set -x color_vi_mode_visual           bryellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  brcyan $colorfg
      set -x btf_prompt_k8s_color                      magenta white --bold
      set -x btf_prompt_username_color                 grey black --bold
      set -x btf_prompt_hostname_color                 grey black
      set -x btf_prompt_rvm_color                      brmagenta $colorfg --bold
      set -x btf_prompt_virtualfish_color              brblue $colorfg --bold
      set -x btf_prompt_virtualgo_color                brblue $colorfg --bold
      set -x btf_prompt_desk_color                     brblue $colorfg --bold

# ------------------------------------------
    case 'zenburn'
      set -l grey   333333 # a bit darker than normal zenburn grey
      set -l red    CC9393
      set -l green  7F9F7F
      set -l yellow E3CEAB
      set -l orange DFAF8F
      set -l blue   8CD0D3
      set -l white  DCDCCC

      set -x color_initial_segment_exit     $white $red --bold
      set -x color_initial_segment_su       $white $green --bold
      set -x color_initial_segment_jobs     $white $blue --bold

      set -x color_path                     $grey $white
      set -x color_path_basename            $grey $white --bold
      set -x color_path_nowrite             $grey $red
      set -x color_path_nowrite_basename    $grey $red --bold

      set -x color_repo                     $green $grey
      set -x color_repo_work_tree           $grey $grey --bold
      set -x color_repo_dirty               $red $grey
      set -x color_repo_staged              $yellow $grey

      set -x color_vi_mode_default          $grey $yellow --bold
      set -x color_vi_mode_insert           $green $white --bold
      set -x color_vi_mode_visual           $yellow $grey --bold

      set -x btf_prompt_vagrant_color                  $blue $green --bold
      set -x btf_prompt_k8s_color                      $green $white --bold
      set -x btf_prompt_username_color                 $grey $blue --bold
      set -x btf_prompt_hostname_color                 $grey $blue
      set -x btf_prompt_rvm_color                      $red $grey --bold
      set -x btf_prompt_virtualfish_color              $blue $grey --bold
      set -x btf_prompt_virtualgo_color                $blue $grey --bold
      set -x btf_prompt_desk_color                     $blue $grey --bold

    case 'base16-light'
      set -l base00 181818
      set -l base01 282828
      set -l base02 383838
      set -l base03 585858
      set -l base04 b8b8b8
      set -l base05 d8d8d8
      set -l base06 e8e8e8
      set -l base07 f8f8f8
      set -l base08 ab4642 # red
      set -l base09 dc9656 # orange
      set -l base0A f7ca88 # yellow
      set -l base0B a1b56c # green
      set -l base0C 86c1b9 # cyan
      set -l base0D 7cafc2 # blue
      set -l base0E ba8baf # violet
      set -l base0F a16946 # brown

      set -l colorfg $base00

      set -x color_initial_segment_exit     $base02 $base08 --bold
      set -x color_initial_segment_su       $base02 $base0B --bold
      set -x color_initial_segment_jobs     $base02 $base0D --bold

      set -x color_path                     $base06 $base02
      set -x color_path_basename            $base06 $base01 --bold
      set -x color_path_nowrite             $base06 $base08
      set -x color_path_nowrite_basename    $base06 $base08 --bold

      set -x color_repo                     $base0B $colorfg
      set -x color_repo_work_tree           $base06 $colorfg --bold
      set -x color_repo_dirty               $base08 $colorfg
      set -x color_repo_staged              $base09 $colorfg

      set -x color_vi_mode_default          $base04 $colorfg --bold
      set -x color_vi_mode_insert           $base0B $colorfg --bold
      set -x color_vi_mode_visual           $base09 $colorfg --bold

      set -x btf_prompt_vagrant_color                  $base0C $colorfg --bold
      set -x btf_prompt_k8s_color                      $base06 $colorfg --bold
      set -x btf_prompt_username_color                 $base02 $base0D --bold
      set -x btf_prompt_hostname_color                 $base02 $base0D
      set -x btf_prompt_rvm_color                      $base08 $colorfg --bold
      set -x btf_prompt_virtualfish_color              $base0D $colorfg --bold
      set -x btf_prompt_virtualgo_color                $base0D $colorfg --bold
      set -x btf_prompt_desk_color                     $base0D $colorfg --bold

    case 'base16' 'base16-dark'
      set -l base00 181818
      set -l base01 282828
      set -l base02 383838
      set -l base03 585858
      set -l base04 b8b8b8
      set -l base05 d8d8d8
      set -l base06 e8e8e8
      set -l base07 f8f8f8
      set -l base08 ab4642 # red
      set -l base09 dc9656 # orange
      set -l base0A f7ca88 # yellow
      set -l base0B a1b56c # green
      set -l base0C 86c1b9 # cyan
      set -l base0D 7cafc2 # blue
      set -l base0E ba8baf # violet
      set -l base0F a16946 # brown

      set -l colorfg $base07

      set -x color_initial_segment_exit     $base05 $base08 --bold
      set -x color_initial_segment_su       $base05 $base0B --bold
      set -x color_initial_segment_jobs     $base05 $base0D --bold

      set -x color_path                     $base02 $base05
      set -x color_path_basename            $base02 $base06 --bold
      set -x color_path_nowrite             $base02 $base08
      set -x color_path_nowrite_basename    $base02 $base08 --bold

      set -x color_repo                     $base0B $colorfg
      set -x color_repo_work_tree           $base02 $colorfg --bold
      set -x color_repo_dirty               $base08 $colorfg
      set -x color_repo_staged              $base09 $colorfg

      set -x color_vi_mode_default          $base03 $colorfg --bold
      set -x color_vi_mode_insert           $base0B $colorfg --bold
      set -x color_vi_mode_visual           $base09 $colorfg --bold

      set -x btf_prompt_vagrant_color                  $base0C $colorfg --bold
      set -x btf_prompt_k8s_color                      $base0B $colorfg --bold
      set -x btf_prompt_username_color                 $base02 $base0D --bold
      set -x btf_prompt_hostname_color                 $base02 $base0D
      set -x btf_prompt_rvm_color                      $base08 $colorfg --bold
      set -x btf_prompt_virtualfish_color              $base0D $colorfg --bold
      set -x btf_prompt_virtualgo_color                $base0D $colorfg --bold
      set -x btf_prompt_desk_color                     $base0D $colorfg --bold

    case 'solarized-light'
      set -l base03  002b36
      set -l base02  073642
      set -l base01  586e75
      set -l base00  657b83
      set -l base0   839496
      set -l base1   93a1a1
      set -l base2   eee8d5
      set -l base3   fdf6e3
      set -l yellow  b58900
      set -l orange  cb4b16
      set -l red     dc322f
      set -l magenta d33682
      set -l violet  6c71c4
      set -l blue    268bd2
      set -l cyan    2aa198
      set -l green   859900

      set colorfg $base03

      set -x color_initial_segment_exit     $base02 $red --bold
      set -x color_initial_segment_su       $base02 $green --bold
      set -x color_initial_segment_jobs     $base02 $blue --bold

      set -x color_path                     $base2 $base00
      set -x color_path_basename            $base2 $base01 --bold
      set -x color_path_nowrite             $base2 $orange
      set -x color_path_nowrite_basename    $base2 $orange --bold

      set -x color_repo                     $green $colorfg
      set -x color_repo_work_tree           $base2 $colorfg --bold
      set -x color_repo_dirty               $red $colorfg
      set -x color_repo_staged              $yellow $colorfg

      set -x color_vi_mode_default          $blue $colorfg --bold
      set -x color_vi_mode_insert           $green $colorfg --bold
      set -x color_vi_mode_visual           $yellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  $violet $colorfg --bold
      set -x btf_prompt_k8s_color                      $green $colorfg --bold
      set -x btf_prompt_username_color                 $base2 $blue --bold
      set -x btf_prompt_hostname_color                 $base2 $blue
      set -x btf_prompt_rvm_color                      $red $colorfg --bold
      set -x btf_prompt_virtualfish_color              $cyan $colorfg --bold
      set -x btf_prompt_virtualgo_color                $cyan $colorfg --bold
      set -x btf_prompt_desk_color                     $cyan $colorfg --bold

    case 'solarized' 'solarized-dark'
      set -l base03  002b36
      set -l base02  073642
      set -l base01  586e75
      set -l base00  657b83
      set -l base0   839496
      set -l base1   93a1a1
      set -l base2   eee8d5
      set -l base3   fdf6e3
      set -l yellow  b58900
      set -l orange  cb4b16
      set -l red     dc322f
      set -l magenta d33682
      set -l violet  6c71c4
      set -l blue    268bd2
      set -l cyan    2aa198
      set -l green   859900

      set colorfg $base3

      set -x color_initial_segment_exit     $base2 $red --bold
      set -x color_initial_segment_su       $base2 $green --bold
      set -x color_initial_segment_jobs     $base2 $blue --bold

      set -x color_path                     $base02 $base0
      set -x color_path_basename            $base02 $base1 --bold
      set -x color_path_nowrite             $base02 $orange
      set -x color_path_nowrite_basename    $base02 $orange --bold

      set -x color_repo                     $green $colorfg
      set -x color_repo_work_tree           $base02 $colorfg --bold
      set -x color_repo_dirty               $red $colorfg
      set -x color_repo_staged              $yellow $colorfg

      set -x color_vi_mode_default          $blue $colorfg --bold
      set -x color_vi_mode_insert           $green $colorfg --bold
      set -x color_vi_mode_visual           $yellow $colorfg --bold

      set -x btf_prompt_vagrant_color                  $violet $colorfg --bold
      set -x btf_prompt_k8s_color                      $green $colorfg --bold
      set -x btf_prompt_username_color                 $base02 $blue --bold
      set -x btf_prompt_hostname_color                 $base02 $blue
      set -x btf_prompt_rvm_color                      $red $colorfg --bold
      set -x btf_prompt_virtualfish_color              $cyan $colorfg --bold
      set -x btf_prompt_virtualgo_color                $cyan $colorfg --bold
      set -x btf_prompt_desk_color                     $cyan $colorfg --bold

    case 'light'
      #               light  medium dark
      #               ------ ------ ------
      set -l red      cc9999 ce000f 660000
      set -l green    addc10 189303 0c4801
      set -l blue     48b4fb 005faf 255e87
      set -l orange   f6b117 unused 3a2a03
      set -l brown    bf5e00 803f00 4d2600
      set -l grey     cccccc 999999 333333
      set -l white    ffffff
      set -l black    000000
      set -l ruby_red af0000

      set -x color_initial_segment_exit     $grey[3] $red[2] --bold
      set -x color_initial_segment_su       $grey[3] $green[2] --bold
      set -x color_initial_segment_jobs     $grey[3] $blue[3] --bold

      set -x color_path                     $grey[1] $grey[2]
      set -x color_path_basename            $grey[1] $grey[3] --bold
      set -x color_path_nowrite             $red[1] $red[3]
      set -x color_path_nowrite_basename    $red[1] $red[3] --bold

      set -x color_repo                     $green[1] $green[3]
      set -x color_repo_work_tree           $grey[1] $white --bold
      set -x color_repo_dirty               $red[2] $white
      set -x color_repo_staged              $orange[1] $orange[3]

      set -x color_vi_mode_default          $grey[2] $grey[3] --bold
      set -x color_vi_mode_insert           $green[2] $grey[3] --bold
      set -x color_vi_mode_visual           $orange[1] $orange[3] --bold

      set -x btf_prompt_vagrant_color                  $blue[1] $white --bold
      set -x btf_prompt_k8s_color                      $green[1] $colorfg --bold
      set -x btf_prompt_username_color                 $grey[1] $blue[3] --bold
      set -x btf_prompt_hostname_color                 $grey[1] $blue[3]
      set -x btf_prompt_rvm_color                      $ruby_red $grey[1] --bold
      set -x btf_prompt_virtualfish_color              $blue[2] $grey[1] --bold
      set -x btf_prompt_virtualgo_color                $blue[2] $grey[1] --bold
      set -x btf_prompt_desk_color                     $blue[2] $grey[1] --bold

    case 'gruvbox'
      #               light  medium  dark  darkest
      #               ------ ------ ------ -------
      set -l red      fb4934 cc241d
      set -l green    b8bb26 98971a
      set -l yellow   fabd2f d79921
      set -l aqua     8ec07c 689d6a
      set -l blue     83a598 458588
      set -l grey     cccccc 999999 333333
      set -l fg       fbf1c7 ebdbb2 d5c4a1 a89984
      set -l bg       504945 282828

      set -x color_initial_segment_exit  $fg[1] $red[2] --bold
      set -x color_initial_segment_su    $fg[1] $green[2] --bold
      set -x color_initial_segment_jobs  $fg[1] $aqua[2] --bold

      set -x color_path                  $bg[1] $fg[2]
      set -x color_path_basename         $bg[1] $fg[2] --bold
      set -x color_path_nowrite          $red[1] $fg[2]
      set -x color_path_nowrite_basename $red[1] $fg[2] --bold

      set -x color_repo                  $green[2] $bg[1]
      set -x color_repo_work_tree        $bg[1] $fg[2] --bold
      set -x color_repo_dirty            $red[2] $fg[2]
      set -x color_repo_staged           $yellow[1] $bg[1]

      set -x color_vi_mode_default       $fg[4] $bg[2] --bold
      set -x color_vi_mode_insert        $blue[1] $bg[2] --bold
      set -x color_vi_mode_visual        $yellow[1] $bg[2] --bold

      set -x btf_prompt_vagrant_color               $blue[2] $fg[2] --bold
      set -x btf_prompt_k8s_color                   $green[2] $fg[2] --bold
      set -x btf_prompt_username_color              $fg[3] $blue[2] --bold
      set -x btf_prompt_hostname_color              $fg[3] $blue[2]
      set -x btf_prompt_rvm_color                   $red[2] $fg[2] --bold
      set -x btf_prompt_virtualfish_color           $blue[2] $fg[2] --bold
      set -x btf_prompt_virtualgo_color             $blue[2] $fg[2] --bold
      set -x btf_prompt_desk_color                  $blue[2] $fg[2] --bold

    case 'dracula' # https://draculatheme.com
      set -l bg           282a36
      set -l current_line 44475a
      set -l selection    44475a
      set -l fg           f8f8f2
      set -l comment      6272a4
      set -l cyan         8be9fd
      set -l green        50fa7b
      set -l orange       ffb86c
      set -l pink         ff79c6
      set -l purple       bd93f9
      set -l red          ff5555
      set -l yellow       f1fa8c

      set -x color_initial_segment_exit  $fg $red  --bold
      set -x color_initial_segment_su    $fg $purple --bold
      set -x color_initial_segment_jobs  $fg $comment --bold

      set -x color_path                  $selection $fg
      set -x color_path_basename         $selection $fg --bold
      set -x color_path_nowrite          $selection $red
      set -x color_path_nowrite_basename $selection $red --bold

      set -x color_repo                  $green $bg
      set -x color_repo_work_tree        $selection $fg --bold
      set -x color_repo_dirty            $red $bg
      set -x color_repo_staged           $yellow $bg

      set -x color_vi_mode_default       $bg $yellow --bold
      set -x color_vi_mode_insert        $green $bg --bold
      set -x color_vi_mode_visual        $orange $bg --bold

      set -x btf_prompt_vagrant_color               $pink $bg --bold
      set -x btf_prompt_k8s_color                   $green $fg --bold
      set -x btf_prompt_username_color              $selection $cyan --bold
      set -x btf_prompt_hostname_color              $selection $cyan
      set -x btf_prompt_rvm_color                   $red $bg --bold
      set -x btf_prompt_virtualfish_color           $comment $bg --bold
      set -x btf_prompt_virtualgo_color             $cyan $bg --bold
      set -x btf_prompt_desk_color                  $comment $bg --bold

    case '*' # default dark theme
      #               light  medium dark
      #               ------ ------ ------
      set -l red      cc9999 ce000f 660000
      set -l green    addc10 189303 0c4801
      set -l blue     48b4fb 005faf 255e87
      set -l orange   f6b117 unused 3a2a03
      set -l brown    bf5e00 803f00 4d2600
      set -l grey     cccccc 999999 333333
      set -l white    ffffff
      set -l black    000000
      set -l ruby_red af0000
      set -l go_blue  00d7d7

      set -x color_initial_segment_exit     $white $red[2] --bold
      set -x color_initial_segment_su       $white $green[2] --bold
      set -x color_initial_segment_jobs     $white $blue[3] --bold

      set -x color_path                     $grey[3] $grey[2]
      set -x color_path_basename            $grey[3] $white --bold
      set -x color_path_nowrite             $red[3] $red[1]
      set -x color_path_nowrite_basename    $red[3] $red[1] --bold

      set -x color_repo                     $green[1] $green[3]
      set -x color_repo_work_tree           $grey[3] $white --bold
      set -x color_repo_dirty               $red[2] $white
      set -x color_repo_staged              $orange[1] $orange[3]

      set -x color_vi_mode_default          $grey[2] $grey[3] --bold
      set -x color_vi_mode_insert           $green[2] $grey[3] --bold
      set -x color_vi_mode_visual           $orange[1] $orange[3] --bold

      set -x btf_prompt_vagrant_color                  $blue[1] $white --bold
      set -x btf_prompt_k8s_color                      $green[2] $white --bold
      set -x btf_prompt_username_color                 $grey[1] $blue[3] --bold
      set -x btf_prompt_hostname_color                 $grey[1] $blue[3]
      set -x btf_prompt_rvm_color                      $ruby_red $grey[1] --bold
      set -x btf_prompt_virtualfish_color              $blue[2] $grey[1] --bold
      set -x btf_prompt_virtualgo_color                $go_blue $black --bold
      set -x btf_prompt_desk_color                     $blue[2] $grey[1] --bold
  end

  set_default -x btf_prompt_cmd_duration_color $btf_prompt_virtualgo_color
  set_default -x btf_prompt_timestamp_color $btf_prompt_vagrant_color
  set_default -x btf_prompt_vaulted_color $btf_prompt_vagrant_color
end
