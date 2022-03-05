function vmls
  ls -d /Users/abai/Virtual\ Machines.localized/*
end

function vmstart
  vmrun start /Users/abai/Virtual\ Machines.localized/Fedora\ 64-bit.vmwarevm/Fedora\ 64-bit.vmx nogui
  # Enable Vmware Tools in guest
  # also don't show output to stdout and stderr
  vmrun installTools /Users/abai/Virtual\ Machines.localized/Fedora\ 64-bit.vmwarevm/Fedora\ 64-bit.vmx &> /dev/null &
end

function vmstop
  vmrun stop /Users/abai/Virtual\ Machines.localized/Fedora\ 64-bit.vmwarevm/Fedora\ 64-bit.vmx
end

function vmssh
  set -l vm_ip_addr (vmrun getGuestIPAddress /Users/abai/Virtual\ Machines.localized/Fedora\ 64-bit.vmwarevm/Fedora\ 64-bit.vmx)
  test -z $vm_ip_addr ;and echo '$vm_ip_addr is empty, exiting..' ;and exit 1
  ssh abai@$vm_ip_addr
end
