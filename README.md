# Zabbix Icinga 1 Stats
Based on https://github.com/sewata/getnagiostats but converted for icinga 1.14 
and zabbix 2.2  

Uses the `zabbix-agent` as a way to gather the stats, and not `zabbix_sender` 
as so many other scripts/templates do.  

To make the params available, you need to add the userparameter config as in 
`icingastats.conf` to your host, and make sure to set the path properly to the 
`icinga-stats.sh` script.
