#!/bin/bash 
#Script that Downloads the Emerging Threats - Shadowserver C&C List, #Spamhaus 
#DROP Nets, Dshield Top Attackers, Known RBN Nets #and IPs, Compromised IP List, 
#RBN Malvertisers IP List;  AlienVault - IP Reputation Database; ZeuS Tracker - 
#IP Block List; SpyEye Tracker - IP Block List; Palevo Tracker - IP Block List; 
#SSLBL - SSL Blacklist; Malc0de Blacklist; Binary Defense Systems Artillery 
#Threat Intelligence Feed and Banlist Feedand then strips any junk/formatting 
#that can't be used and creates Splunk-ready inputs.    
#   
#Feel free to use and modify as needed   
#   
#Author: Adrian Daucourt based on work from Keith
#(http://#sysadminnygoodness.blogspot.com)   
#
#==============================================================================
#Fix error when calling script from Splunk
#==============================================================================

unset LD_LIBRARY_PATH
filePath='/mnt/c/temp/ipRep'

#==============================================================================
#Emerging Threats - Shadowserver C&C List, Spamhaus DROP Nets, Dshield Top
#Attackers
#==============================================================================

wget http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt -O /tmp/emerging-Block-IPs.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/emerging_threats_shadowserver_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/# \Shadowserver C&C List/d' -e '/#/,$d' | sed -n '/^[0-9]/p' | sed 's/$/ Shadowserver IP/' >> $filePath/ipRepData/emerging_threats_shadowserver_ips.txt

#echo "# Generated: `date`" > $filePath/ipRepData/emerging_threats_spamhaus_drop_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/#Spamhaus DROP Nets/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Spamhaus IP/' >> $filePath/ipRepData/emerging_threats_spamhaus_drop_ips.txt

#echo "# Generated: `date`" > $filePath/ipRepData/emerging_threats_dshield_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/#Dshield Top Attackers/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Dshield IP/' >> $filePath/ipRepData/emerging_threats_dshield_ips.txt

rm /tmp/emerging-Block-IPs.txt

#==============================================================================
#Emerging Threats - Compromised IP List
#==============================================================================

wget http://rules.emergingthreats.net/blockrules/compromised-ips.txt -O /tmp/compromised-ips.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/emerging_threats_compromised_ips.txt

cat /tmp/compromised-ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Compromised IP/' >> $filePath/ipRepData/emerging_threats_compromised_ips.txt

rm /tmp/compromised-ips.txt

#==============================================================================
#Binary Defense Systems Artillery Threat Intelligence Feed and Banlist Feed
#==============================================================================

wget http://www.binarydefense.com/banlist.txt -O /tmp/binary_defense_ips.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/binary_defense_ban_list.txt

cat /tmp/binary_defense_ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Binary Defense IP/' >> $filePath/ipRepData/binary_defense_ban_list.txt

rm /tmp/binary_defense_ips.txt

#==============================================================================
#AlienVault - IP Reputation Database
#==============================================================================

wget https://reputation.alienvault.com/reputation.snort.gz -P /tmp --no-check-certificate -N

gzip -d /tmp/reputation.snort.gz

#echo "# Generated: `date`" > $filePath/ipRepData/av_ip_rep_list.txt

cat /tmp/reputation.snort | sed -n '/^[0-9]/p' | sed "s/# //">> $filePath/ipRepData/av_ip_rep_list.txt

rm /tmp/reputation.snort

#==============================================================================
#SSLBL - SSL Blacklist
#==============================================================================

wget https://sslbl.abuse.ch/blacklist/sslipblacklist.csv -O /tmp/sslipblacklist.csv --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/sslipblacklist.txt

cat /tmp/sslipblacklist.csv | sed -n '/^[0-9]/p' | cut -d',' -f1,3 | sed "s/,/ /" | sed 's/$/ SSLBL IP/' >> $filePath/ipRepData/sslipblacklist.txt

rm /tmp/sslipblacklist.csv

#==============================================================================
#ZeuS Tracker - IP Block List
#==============================================================================

wget https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist -O /tmp/zeustracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/zeus_ip_block_list.txt

cat /tmp/zeustracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Zeus IP/' >> $filePath/ipRepData/zeus_ip_block_list.txt

rm /tmp/zeustracker.txt

#==============================================================================
#RansomeWare Tracker - IP Block List
#==============================================================================

wget http://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt -O /tmp/ransomewaretracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/ransomeware_ip_block_list.txt

cat /tmp/ransomewaretracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Spyeye IP/' >> $filePath/ipRepData/ransomewaretracker.txt

rm /tmp/ransomewaretracker.txt

#==============================================================================
#Feodo Tracker - IP Block List
#==============================================================================

wget https://feodotracker.abuse.ch/blocklist/?download=ipblocklist -O /tmp/feodotracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/feodo_ip_block_list.txt

cat /tmp/feodotracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Spyeye IP/' >> $filePath/ipRepData/feodotracker.txt

rm /tmp/feodotracker.txt

#==============================================================================
#Palevo Tracker - IP Block List
#==============================================================================

wget https://palevotracker.abuse.ch/blocklists.php?download=ipblocklist -O /tmp/palevotracker.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/palevo_ip_block_list.txt

cat /tmp/palevotracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Palevo IP/' >> $filePath/ipRepData/palevo_ip_block_list.txt

rm /tmp/palevotracker.txt

#==============================================================================
#Malc0de - Malc0de Blacklist
#==============================================================================

wget http://malc0de.com/bl/IP_Blacklist.txt -O /tmp/IP_Blacklist.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/malc0de_black_list.txt

cat /tmp/IP_Blacklist.txt | sed -n '/^[0-9]/p' | sed 's/$/ Malc0de IP/' >> $filePath/ipRepData/malc0de_black_list.txt

rm /tmp/IP_Blacklist.txt

#==============================================================================
#Talos-Intelligence
#==============================================================================

wget https://www.talosintelligence.com/documents/ip-blacklist -O /tmp/IP_Blacklist.txt --no-check-certificate -N

#echo "# Generated: `date`" > $filePath/ipRepData/Talos_black_list.txt

cat /tmp/IP_Blacklist.txt | sed -n '/^[0-9]/p' | sed 's/$/ Malc0de IP/' >> $filePath/ipRepData/malc0de_black_list.txt

rm /tmp/IP_Blacklist.txt
