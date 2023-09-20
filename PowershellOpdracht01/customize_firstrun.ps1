# Zoek schijf 'bootfs'
$bootfsDrive = Get-WmiObject -Class Win32_Volume | Where-Object { $_.Label -eq 'bootfs' }

# is schijf gevonden?
if ($bootfsDrive -ne $null) {
    # Maak het pad naar het bestand firstrun.sh
    $firstrunPath = Join-Path -Path $bootfsDrive.DriveLetter -ChildPath 'firstrun.sh'

    # zoek firstrun.sh
    if (Test-Path $firstrunPath) {
        # Lees firstrun.sh
        $firstrunContent = Get-Content $firstrunPath

        # Zoek 'rm -f /boot/firstrun.sh'
        $removeLineIndex = $firstrunContent | Where-Object { $_ -match 'rm -f /boot/firstrun.sh' } | Select-Object -First 1

        if ($removeLineIndex -ne $null) {
            # Controleer of file reeds is aangepast
            $bashCodeAdded = $firstrunContent | Where-Object { $_ -match 'MCT - Computer Networks section' }

            if ($bashCodeAdded -eq $null) {
                # Voeg de bash-code toe vóór regel
                $bashCode = @"
cat >>/etc/dhcpcd.conf <<'DHCPCDEOF'

#
# MCT - Computer Networks section
#
# DHCP fallback profile

profile static_eth0
static ip_address=192.168.168.168/24

# The primary network interface
interface eth0
arping 192.168.99.99
fallback static_eth0

#static ip_address=<IP address>/<prefix>
#static routers=<IP address default gateway>
#static domain_name_servers=<preferred DNS server> <alternate DNS server>
DHCPCDEOF
"@

                $firstrunContent = $firstrunContent -replace 'rm -f /boot/firstrun.sh', "$bashCode`n`$&"

                # Schrijf inhoud terug
                Set-Content $firstrunPath $firstrunContent
                Write-Output "Script aangepast."
            } else {
                Write-Output "code is reeds toegevoegd."
            }
        } else {
            Write-Output "Regel 'rm -f /boot/firstrun.sh' niet gevonden in firstrun.sh."
        }
    } else {
        Write-Output "Bestand firstrun.sh niet gevonden."
    }
} else {
    Write-Output "Schijf met label 'bootfs' niet gevonden."
}
