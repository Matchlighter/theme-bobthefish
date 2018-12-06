function set_default -S -d 'Set the default value of a variable'
  set -l flags
  while [ -n "$argv" ]
    if [ (string sub -l 1 -- "$argv[1]") = '-' ]
      set flags $flags $argv[1]
      set -e argv[1]
    else
      break
    end
  end

  test -n "$$argv[1]"; or set $flags $argv
end