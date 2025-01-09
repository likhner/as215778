#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
configure

set system name-server 1.1.1.1
set system name-server 8.8.8.8
set system name-server 2606:4700:4700::1111
set system name-server 2001:4860:4860::8888

set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 ipv6 disable-forwarding
set service router-advert interface eth0 no-send-advert

set interfaces ethernet eth1 address 2a11:f2c0:ffcb::1/48
set service router-advert interface eth1 prefix 2a11:f2c0:ffcb:6c69::/64
set service router-advert interface eth1 name-server 2606:4700:4700::1111
set service router-advert interface eth1 name-server 2001:4860:4860::8888
set service router-advert interface eth1 other-config-flag

set interfaces wireguard wg0 address 2a0c:9a40:a005::a/126
set interfaces wireguard wg0 private-key REDACTED
set interfaces wireguard wg0 peer ifog address REDACTED
set interfaces wireguard wg0 peer ifog port 51905
set interfaces wireguard wg0 peer ifog public-key REDACTED
set interfaces wireguard wg0 peer ifog allowed-ips 2a0c:9a40:a005::8/126 # actually 2a0c:9a40:a005::9/126
set interfaces wireguard wg0 peer ifog persistent-keepalive 60
set protocols static route6 ::/0 next-hop 2a0c:9a40:a005::9 interface wg0
set protocols static route6 ::/0 interface wg0 distance 10

set interfaces wireguard wg1 address 2a0f:e586:f:f747::20/64
set interfaces wireguard wg1 private-key REDACTED
set interfaces wireguard wg1 peer urdn address REDACTED
set interfaces wireguard wg1 peer urdn port 4469
set interfaces wireguard wg1 peer urdn public-key REDACTED
set interfaces wireguard wg1 peer urdn allowed-ips 2a0f:e586:f:f747::10/128
set interfaces wireguard wg1 peer urdn persistent-keepalive 60
set protocols static route6 ::/0 next-hop 2a0f:e586:f:f747::10 interface wg1
set protocols static route6 ::/0 interface wg1 distance 20

set interfaces tunnel tun0 encapsulation gre
set interfaces tunnel tun0 address 2a01:20e:1000:1b1::2/126
set interfaces tunnel tun0 source-address 203.0.113.1
set interfaces tunnel tun0 remote REDACTED
set protocols static route6 ::/0 next-hop 2a01:20e:1000:1b1::1 interface tun0
set protocols static route6 ::/0 interface tun0 distance 30

set interfaces tunnel tun1 encapsulation gre
set interfaces tunnel tun1 address 2a01:d0:7fff:244::2/126
set interfaces tunnel tun1 source-address 203.0.113.1
set interfaces tunnel tun1 remote REDACTED
set protocols static route6 ::/0 next-hop 2a01:d0:7fff:244::1 interface tun1
set protocols static route6 ::/0 interface tun1 distance 40

set interfaces tunnel tun2 encapsulation gre
set interfaces tunnel tun2 address fd72:538d:9a5e::2/126
set interfaces tunnel tun2 source-address 203.0.113.1
set interfaces tunnel tun2 remote REDACTED
set protocols static route6 ::/0 next-hop fd72:538d:9a5e::1 interface tun2
set protocols static route6 ::/0 interface tun2 distance 50

set interfaces tunnel tun3 encapsulation gre
set interfaces tunnel tun3 address fc82::2/126
set interfaces tunnel tun3 source-address 203.0.113.1
set interfaces tunnel tun3 remote REDACTED
set protocols static route6 ::/0 next-hop fc82::1 interface tun3
set protocols static route6 ::/0 interface tun3 distance 60

set protocols rpki cache 91.206.229.249 port 3323
set protocols rpki cache rpki.level66.network preference 1

set protocols bgp system-as 215778
set protocols bgp parameters router-id 203.0.113.1

set protocols bgp neighbor 2a0c:9a40:a005::9 remote-as 209533
set protocols bgp neighbor 2a0c:9a40:a005::9 update-source 2a0c:9a40:a005::a
set protocols bgp neighbor 2a0c:9a40:a005::9 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor 2a0c:9a40:a005::9 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor 2a0c:9a40:a005::9 address-family ipv6-unicast soft-reconfiguration inbound

set protocols bgp neighbor 2a0f:e586:f:f747::10 remote-as 207656
set protocols bgp neighbor 2a0f:e586:f:f747::10 update-source 2a0f:e586:f:f747::20
set protocols bgp neighbor 2a0f:e586:f:f747::10 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor 2a0f:e586:f:f747::10 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor 2a0f:e586:f:f747::10 address-family ipv6-unicast soft-reconfiguration inbound

set protocols bgp neighbor 2a01:20e:1000:1b1::1 remote-as 41051
set protocols bgp neighbor 2a01:20e:1000:1b1::1 update-source 2a01:20e:1000:1b1::2
set protocols bgp neighbor 2a01:20e:1000:1b1::1 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor 2a01:20e:1000:1b1::1 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor 2a01:20e:1000:1b1::1 address-family ipv6-unicast soft-reconfiguration inbound

set protocols bgp neighbor 2a01:d0:7fff:244::1 remote-as 29632
set protocols bgp neighbor 2a01:d0:7fff:244::1 update-source 2a01:d0:7fff:244::2
set protocols bgp neighbor 2a01:d0:7fff:244::1 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor 2a01:d0:7fff:244::1 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor 2a01:d0:7fff:244::1 address-family ipv6-unicast soft-reconfiguration inbound

set protocols bgp neighbor fd72:538d:9a5e::1 remote-as 34465
set protocols bgp neighbor fd72:538d:9a5e::1 update-source fd72:538d:9a5e::2
set protocols bgp neighbor fd72:538d:9a5e::1 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor fd72:538d:9a5e::1 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor fd72:538d:9a5e::1 address-family ipv6-unicast soft-reconfiguration inbound

set protocols bgp neighbor fc82::1 remote-as 393577
set protocols bgp neighbor fc82::1 update-source fc82::2
set protocols bgp neighbor fc82::1 address-family ipv6-unicast route-map import AS215778-IN
set protocols bgp neighbor fc82::1 address-family ipv6-unicast route-map export AS215778-OUT
set protocols bgp neighbor fc82::1 address-family ipv6-unicast soft-reconfiguration inbound

set policy route-map AS215778-IN rule 10 action permit
set policy route-map AS215778-IN rule 10 match rpki valid
set policy route-map AS215778-IN rule 10 set local-preference 200

set policy route-map AS215778-IN rule 20 action permit
set policy route-map AS215778-IN rule 20 match rpki notfound
set policy route-map AS215778-IN rule 20 set local-preference 100

set policy route-map AS215778-IN rule 30 action deny
set policy route-map AS215778-IN rule 30 match rpki invalid

set policy route-map AS215778-OUT rule 10 action permit
set policy route-map AS215778-OUT rule 10 match ipv6 address prefix-list AS215778-OUT

set policy prefix-list6 AS215778-OUT rule 10 action permit
set policy prefix-list6 AS215778-OUT rule 10 prefix 2a11:f2c0:ffcb::/48

set policy prefix-list6 AS215778-OUT rule 20 action deny
set policy prefix-list6 AS215778-OUT rule 20 prefix ::/0

set protocols static route6 2a11:f2c0:ffcb::/48 blackhole distance 254

commit
save
