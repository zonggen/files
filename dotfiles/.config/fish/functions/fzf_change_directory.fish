function _fzf_change_directory
  if [ (count $argv) ]
    fzf --layout=reverse --query "$argv " | perl -pe 's/([ ()])/\\\\$1/g' | read foo
  else
    fzf --layout=reverse | perl -pe 's/([ ()])/\\\\$1/g' | read foo
  end

  if [ $foo ]
    builtin cd $foo
    commandline -r ''
    commandline -f repaint
  else
    commandline ''
  end
end

function fzf_change_directory
  begin
    # Add the list of directories you want to search for
    z -l | awk '{print $2}'
    # Search $HOME and $PWD
    find $HOME -maxdepth 2 -type d ! -path '*/.git' ! -path '*/.git/*' 2> /dev/null
    test $PWD != $HOME && find $PWD -maxdepth 2 -type d ! -path '*/.git' ! -path '*/.git/*' 2> /dev/null
  end \
  | sed -e 's/\/$//' \
  | awk '!a[$0]++' \
  | _fzf_change_directory $argv
end
