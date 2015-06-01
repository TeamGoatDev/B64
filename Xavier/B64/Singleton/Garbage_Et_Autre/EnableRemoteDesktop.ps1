# Enable Remote Desktop
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

# Allow incoming RDP on firewall
Enable-NetFirewallRule -DisplayGroup "Bureau à distance"

# Enable secure RDP authentication
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1 