eduroam
kamplinux@ogrenci.ibu.edu.tr


nano /etc/network/interfaces

auto enp0s8

iface enp0s8 inet dhcp

sudo systemctl restart networking

hostnamectl set-hostname pgdb01

-----------------------
nano /etc/hosts
debian > pgdb01

---------------------
apt install sudo vim bash-completion ca-certificates cloud-utils rsync parted telnet libjson-perl python3-psycopg2 python3-apt python3-pip python3-netaddr apt-transport-https lsof fio gpg locales sysstat iotop iftop net-tools unzip zip man psmisc curl parallel atop tmux jq tcpdump hping3 acl tuned-utils tuned ssl-cert fdisk strace htop

	To manually configure the Apt repository, follow these steps:
https://www.postgresql.org/download/linux/debian/


apt install postgresql-16

sudo su - postgres

pg_lsclusters 
	clusterlari listeler

systemctl stop postgresql@16...
systemctl status postgresql@16-main.service

pg_dropcluster *version*(16) *cluster-ismi*(main)
	systemctl daemon-reload


		lsblk

mkfs.ext4 /dev/sdb
	ext4 formatinda sdbyi formatliyor
mkdir /pg_data
mount /dev/sdb /pg_data


blkid
	/dev/sdb UUID

UUID="e0c63ed7-3076-457f-8c36-d220160e15cc"

vim /etc/fstab
UUID=e0c63ed7-3076-457f-8c36-d220160e15cc   /pg_data   ext4   defaults   0   0

reboot -h now


pg_data ownerini roottan postgresql e vercez
chown postgres: pg_data/     dizin sahipligi
chmod 700 /pg_data/             dizin yetkileri

su - postgres
cd /pg_data
mkdir 16
chmod 700 16

pg_createcluster 16 lkd -D /pg_data/16/lkd

systemctl start postgresql@16-lkd.service

sudo su - postgres
pg_lsclusters


//alter system set log_min_duration_statement TO  '1ms';
from pg_settings where pending restart;

select * from pg_settings where pending_restart ;
 \x







select pg_create_physical_replication_slot('standby_slot',true)
vim /etc/postgresql/16/lkd/pg_hba.conf
host replication standby 192.168.56.101/32 veya /0 scram-sha-256


select * from pg_hba_file_rules;


vim .pgpass
chmod 600 .pgpass



1
select * from pg_replication_slots;
select * from pg_replication;



?????????????????/
\c lkd_test
select user;
set session authorization burak;

set work_mem TO 8mb; only sets for burak
alter system set work_mem 8mb 

\dn
list of schemas
alter schema public owner to burak;

create table lkd_table(a serial, b text);

show search_path;




??????????
show wal_level;
	streaming replication icin wal lev, logical replication icin degil.
alter system set wal_level to 'logical';
select user;
reset session authorization;
alter system set wal_level to 'logical';
select pg_load_conf();
select * from pg_settings where pending_restart;



systemctl restart postgresql@16-lkd.service;


insert into public.lkd_table values ('lkd')


CREATE PUBLICATION my_publication FOR TABLE my_table;
CREATE PUBLICATION my_publication FOR TABLE table1, table2, table3;

CREATE PUBLICATION my_publication FOR TABLE table1 , table2, table3
WITH ()


CONNECTION 'host'=master_
PUBLICATION my_publication;


CREATE PUBLICATION lkd_pub FOR TABLE public.lkd_table;

select * from pg_publication;
select * from pg_publication_tables;






alter table lkd_table add primary key (a);




/etc/postgresql/16/lkd/pg_hba.conf
host replication pub_user 192.168.56.105/32 scram-sha-256
psql
select pg_reload_conf();
select * from pg_hba.conf();

CREATE SUBSCRIPTION logical_sub
CONNECTION 'host=192.168.56.104 dbname=lkd_test user=pub_user password=1234'
PUBLICATION my_publication;



apt install pgbackrest


[global] 
repo1-host=192.168.56.103
repo1-host-user=postgres
log-level-file=info
log-level-console=info
archive-async=y

[global:archive-get]
process-max=1

[global:archive-push] 
process-max=1

[pg16_lkd] 
pg1-path= /pg_data/16/lkd
pg1-socket-path=/var/run/postgresql


[global]  
repo1-path=/pg_backup/pgbackrest/repo  
repo1-retention-full=2  
repol-retention-diff=1 
process-max=1  
start-fast=y  
stop-auto=y  
log-path=/pg_backup/pgbackrest/log
log-level-file=info  
log-level-console=info  
backup-standby=n  
resume=n  
exclude=log/  

[pg16_lkd]  
pg1-path=/pg_data/16/lkd
pg1-host=192.168.56.101
pg1-host-user=postgres
pg2-path=/pg_data/16/lkd
pg2-host=192.168.56.102
pg2-host-user=postgres


vim /pg_data/16/lkd/postgresql.auto.conf # pgdb1 uzerinde
archive_command='/usr/bin/pgbackrest --stanza=pg16_lkd archive-push %p'


pgdb2 de
alter system set archive_command TO '/usr/bin/pgbackrest --stanza=pg16_lkd archive push %p';
select pg_reloat_conf();
show archive_command;

ssh-keygen -t rsa -b 4096 #pgdb1de
ssh-keygen -t rsa -b 4096 #pgdb2de

ssh icindeyken authorized_keys e public rsa key yapistir
daha sonra ikinci sunnucu icin aynisinii yap
dah  sonra diger ssh keyleri de birbirine ekle













--------------
pgbackrest info
pgbackrest info --stanza=pg16_lkd check





pg_createcluster 16 lkd_restore -D /pg_data/16/lkd_restore
ii


/usr/bin/pgbackrest --stanza=pg16_lkd --type=standby restore












3 debian sunucu
pgdb01 hostnames
network configuration
hostnameler
default paketler kurulacak
/pg_data mount edilecek sdb


192.168.56.104 pgdb01
192.168.56.105 pgdb02
192.168.56.106 pgdb03

vim /etc/hosts

qtjz1xx6ojT75BwjhDdxTmn97SvBRYfmVG1MRelt3Lg=


{
"domain":  "consul",  
"datacenter": "lkd",
"node name": "pgdb0l",  
"bind addr": "192.168.56.107",  
"client addr": "127.0.0.1 192.168.56.107",  
"data dir": "/var/lib/consul",
"encrypt": "qtjz1xx6ojT75BwjhDdxTmn97SvBRYfmVG1MRelt3Lg=",
"log level": "INFO",  
"log file": "/var/log/consul/consul",
"server": true,
"bootstrap expect": 3,
"ui config": {  "enabled": true },
"telemetry"  { "prefix filter": ["+consul.raft.apply","-consul.http", "+consul.http.GET"] },
"leave_on_terminate": true,
"rejoin after leave": true,
"enable local script checks": true,
"disable update check" : true,
"retry join": ["192.168.56.107", "192.168.56.108" "192.168.56.109"],
"acl": { "enabled" : true, "default_policy" : "deny", "enable_token_persistence" : true, "tokens" : {
"default" : "anonymous",
"agent" : "af0b6df5-8a91-459a-adbe-75002206c4a7",
"initial_management" : "af0b6df5-8a91-459a-adbe-75002206c4a7"
}
}
}





chown consul: /etc/consul.d/consul.json
chmod 600 /etc/consul.d/consul.json

consul validate /etc/consul.d

vim /etc/profile.d/consul.sh
export CONSUL_HTTP_TOKEN_FILE=/etc/consul.d/consul_http_token complete -C /usr/bin/consul consul

chmod 0644 /etc/profile.d/consul.sh

vim /etc/consul.d/consul_http_token
	------
chown consul: /etc/consul.d/consul_http_token
chmod 600 /etc/consul.d/consul_http_token

systemctl enable consul.service
systemctl start consul.service
systemctl status consul.service

consul members
consul operator raft list-peers


#consulun_data_librarysi
cd /var/lib/consul



%include /etc/pg/bouncer/database
