Content-Type: multipart/mixed; boundary="==AWS=="
MIME-Version: 1.0

--==AWS==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
set hostname ${fgt_id}
end
config log setting
set fwpolicy-implicit-log enable
end
config system interface
edit port1                            
set alias public
set mode static
set ip ${fgt_public_ip}
set allowaccess ping
set mtu-override enable
set mtu 9001
next
edit port2
set alias private
set mode static
set ip ${fgt_private_ip}
set allowaccess ping 
set mtu-override enable
set mtu 9001
next
edit port3
set alias 
set mode static
set ip ${fgt_mgmt_ip}
set allowaccess ping https ssh
set mtu-override enable
set mtu 9001
next
edit port4
set alias heartbeat
set mode static
set ip ${fgt_heartbeat_ip}
set allowaccess ping
set mtu-override enable
set mtu 9001
next
end
config router static
edit 1
set device port1
set gateway ${public_gw}
next
edit 2
set device port2
set dst ${allvpc_cidr}
set gateway ${private_gw}
next
end

config firewall address
edit Webvpc
set subnet ${webvpc_cidr}
next
edit Appvpc
set subnet ${appvpc_cidr}
next
edit Dbvpc
set subnet ${dbvpc_cidr}
next
edit Mgmtvpc
set subnet ${mgmtvpc_cidr}
next
edit "internalNLB"
set type fqdn
set fqdn ${fqdn_nlb}
next
end
config firewall vip
edit "fgt_public_eni"
set type fqdn
set extip ${fgt1_public_eni}
set extintf "any"
set portforward enable
set mapped-addr "internalNLB"
set extport 80
set mappedport 80
next
end

config firewall policy
edit 1
set name webvpc_to_appvpc
set srcintf port2
set dstintf port2
set srcaddr Webvpc
set dstaddr Appvpc
set action accept
set schedule always
set service ALL
set utm-status enable
set application-list "default"
set logtraffic all
set logtraffic-start enable
next
edit 2
set name appvpc_to_dbvpc
set srcintf port2
set dstintf port2
set srcaddr Appvpc
set dstaddr Dbvpc
set action accept
set schedule always
set service ALL
set logtraffic all
set logtraffic-start enable
set utm-status enable
set application-list "default"
next
edit 3
set name mgmtvpc_to_allvpc
set srcintf port2
set dstintf port2
set srcaddr Mgmtvpc
set dstaddr "Webvpc" "Appvpc" "Dbvpc"
set action accept
set schedule always
set service ALL
set logtraffic all
set logtraffic-start enable
set utm-status enable
set application-list "default"
next
edit 4
set name "external_access_to_web_server"
set srcintf "port1"
set dstintf "port2"
set action accept
set srcaddr "all"
set dstaddr "fgt_public_eni"
set schedule "always"
set service "HTTP"
set utm-status enable
set ssl-ssh-profile "certificate-inspection"
set application-list "default"
set logtraffic all
set logtraffic-start enable
next 
edit 5
set name allvpc_to_internet
set srcintf port2
set dstintf port1
set srcaddr all
set dstaddr all
set action accept
set schedule always
set service ALL
set logtraffic all
set logtraffic-start enable
set utm-status enable
set application-list "default"
set nat enable
next
end
config system ha
set group-name fortinet
set group-id 1
set password ${password}
set mode a-p
set hbdev port4 50
set session-pickup enable
set ha-mgmt-status enable
config ha-mgmt-interface
edit 1
set interface port3
set gateway ${mgmt_gw}
next
end
set override disable
set priority ${fgt_priority}
set unicast-hb enable
set unicast-hb-peerip ${fgt-remote-heartbeat}
end
config system vdom-exception
edit 1
set object system.interface
next
edit 2
set object router.static
next
edit 3
set object firewall.vip
next
end

%{ if type == "byol" }
--==AWS==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(license_file)}

%{ endif }
--==AWS==--
