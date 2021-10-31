function _peco_change_directory
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'|read foo
  else
    peco --layout=bottom-up |perl -pe 's/([ ()])/\\\\$1/g'|read foo
  end
  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function peco_change_directory
  begin
    # add the list of directory you want to search for
    z -l | awk '{print $2}'
    # search $HOME and $PWD
    find $HOME -maxdepth 2 -type d ! -path '*/.git' ! -path '*/.git/*'
    test $PWD != $HOME && find $PWD -type d ! -path '*/.git' ! -path '*/.git/*'
  # removes trailing '/'
  # removes duplicates with awk: https://unix.stackexchange.com/a/639902
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_change_directory $argv
end
