function wakemypc
  # variables and function for ssh into my windows machine
  # XXX: replace with real mac address
  set -l win10_mac_addr ""

  wakeonlan $win10_mac_addr
end

function ssh_win10
  # XXX: replace with real mac address
  set -l win10_mac_addr ""

  set -l current_ip_addr (ipconfig getifaddr en0)
  test -z $current_ip_addr ;and echo '$current_ip_addr empty, exiting..' ;and exit 1
  echo "macos ipv4: $current_ip_addr"
  set -l win10_ip_addr (sudo nmap -sn 192.168.1.5/24 | grep -B 2 $win10_mac_addr | head -1 | grep -oe "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
  test -z $win10_ip_addr ;and echo '$win10_ip_addr empty, exiting..' ;and exit 1
  echo "win10 ipv4: $win10_ip_addr"
  ssh carpe@$win10_ip_addr
end
