#!/bin/bash

apt install -y nfs-kernel-server || echo "install nfs-kernel server failed"

srv_pr="/var/nfs/gen_r"
srv_prw="/var/nfs/gen_rw"

srv_no_rsquash="/home/no_rsquash"
srv_rsquash="/home/rsquash" 


mkdir -p "$srv_pr"
chown nobody:nogroup "$srv_pr"

mkdir -p "$srv_prw"
chown nobody:nogroup "$srv_prw"

mkdir -p "$srv_no_rsquash"
mkdir -p "$srv_rsquash"

client_ip="192.168.90.102"
cl_prw_op="rw,sync,no_subtree_check"
cl_pr_op="ro,sync,no_subtree_check"
cl_prw_nors="rw,sync,no_subtree_check,no_root_squash"
cl_prw_rs="rw,sync,no_subtree_check"
conf="/etc/exports"


grep -q "$srv_pr" "$conf" && sed -i -e "#${srv_pr}#s#^[#]##g;#${srv_pr}#s#\ .*#${client_ip}($cl_pr_op)" "$conf" || echo "${srv_pr} ${client_ip}($cl_pr_op)" >> "$conf"

grep -q "$srv_prw" "$conf" && sed -i -e "#${srv_prw}#s#^[#]##g;#${srv_prw}#s#\ .*#${client_ip}($cl_prw_op)" "$conf" || echo "${srv_prw} ${client_ip}($cl_prw_op)" >> "$conf"

grep -q "$srv_no_rsquash" "$conf" && sed -i -e "#${srv_no_rsquash}#s#^[#]##g;#${srv_no_rsquash}#s#\ .*#${client_ip}  ($cl_prw_nors)" "$conf" || echo "${srv_no_rsquash} ${client_ip}($cl_prw_nors)" >> "$conf"

grep -q "$srv_rsquash" "$conf" && sed -i -e "#${srv_rsquash}#s#^[#]##g;#${srv_rsquash}#s#\ .*#${client_ip}  ($cl_prw_rs)" "$conf" || echo "${srv_rsquash} ${client_ip}($cl_prw_rs)" >> "$conf"

systemctl restart nfs-kernel-server