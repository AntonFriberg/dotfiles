#!/bin/sh

nmcli connection add \
    type wifi \
    con-name "eduroam" \
    ifname "wlp4s0" \
    ssid "eduroam" \
    wifi-sec.key-mgmt "wpa-eap" \
    802-1x.identity '<STIL-USER>@lu.se' \
    802-1x.password '<STIL-PASS>' \
    802-1x.system-ca-certs 'yes' \
    802-1x.domain-suffix-match 'radius.lu.se' \
    802-1x.eap 'peap' \
    802-1x.phase2-auth 'mschapv2'

nmcli connection up eduroam