
function repeat
  set -l n $argv[1]
  set -e argv[1]
  set -l cmd

  for bit in $argv
    set cmd $cmd (string escape -- "$bit")
  end

  for i in (seq 0 $n)
    [ "$i" = '0' ]; and continue
    eval $cmd
  end
end
