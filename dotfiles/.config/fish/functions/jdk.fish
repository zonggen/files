function jdk --description "List and set JDK versions"
  # ref:
  # - https://fishshell.com/docs/current/cmds/argparse.html
  # - https://mkyong.com/java/how-to-install-java-on-mac-osx
  # - https://stackoverflow.com/questions/16048757/fish-function-option-param-parser
  # - https://www.fbrs.io/fish-options
  set --local options 'h/help' 'l/list' 's/set='

  argparse $options -- $argv

  if set --query _flag_list
    printf "/usr/libexec/java_home -V\n\n"
    /usr/libexec/java_home -V
    printf "ls -l /Library/Java/JavaVirtualMachines"
    ls -l /Library/Java/JavaVirtualMachines
    return 0
  end

  if set --query _flag_set
    set -l jdk_version $_flag_set
    if test -n "$version"
      set -e JAVA_HOME
      set -Ux JAVA_HOME (/usr/libexec/java_home -v"$jdk_version")
      java -version
      return 0
    else
      echo "error: specify version, see versions with '-l/--list'"
      return 1
    end
  end

  printf "Usage: jdk [OPTIONS]\n\n"
  printf "Options:\n"
  printf "  -h/--help         Prints help and exits\n"
  printf "  -l/--list         List available JDK versions\n"
  printf "  -s/--set=VERSION  Set JDK version (e.g. 17)\n"
  return 0
end
