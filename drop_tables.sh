#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

echo "Enter username"
read username

echo "password"
read -s password

sqlplus64 "$username/$password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
drop table Readers cascade constraints;
drop table Staff cascade constraints;
drop table Validation cascade constraints;
drop table Books cascade constraints;
drop table Checkout cascade constraints;
drop table CheckIn cascade constraints;
drop table BookLocation cascade constraints;
drop table Publisher cascade constraints;
exit;
EOF