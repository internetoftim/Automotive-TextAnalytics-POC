#!/bin/bash

dos2unix FLAT_CMPL.txt

#User input for database username and password 
UNAME=$1
PWD=$2
#TODO - incorporate secure login 

#Load complaints table from downloaded complaints data from http://www-odi.nhtsa.dot.gov/downloads/
#the script replaces tab-delimiter to pipe ('|')
cat FLAT_CMPL.txt | sed -e 's/\t/|/g'  > FLAT_CMPL_PIPED.txt
#cat FLAT_CMPL_UTF.txt | sed -e 's/\t/|/g'  > FLAT_CMPL_PIPED_UTF.txt


#Load the NHTSA data to the complaints table 
#ncluster_loader -U $UNAME -w $PWD -d beehive --el-enabled --el-discard-errors car_complaints.nhtsa_cmpl FLAT_CMPL_PIPED.txt -D '|'
#ncluster_loader -U ts186045 -w ts186045 -d beehive --el-enabled --el-discard-errors car_complaints.nhtsa_cmpl FLAT_CMPL_PIPED.txt -D '|'
#ncluster_loader -U ts186045 -w ts186045 -d beehive --el-enabled  car_complaints.nhtsa_cmpl FLAT_CMPL_PIPED_UTF.txt -D '|'
ncluster_loader -U ts186045 -w ts186045 -d beehive --el-enabled --el-label nhtsa_err car_complaints.nhtsa_cmpl FLAT_CMPL_PIPED.txt -D '|'
#ncluster_loader -U beehive -w beehive -d beehive --el-enabled --el-label nhtsa_err car_complaints.nhtsa_cmpl FLAT_CMPL_PIPED.txt -D '|'

#        Total Tuples:    1243680
#        Loaded Tuples:   1235899
#        Malformed Tuples:7781

#Counts the number of lines from the raw NHTSA complaints data
wc -l FLAT_CMPL_PIPED.txt 

#Load the POS tag lookup table from the PENN Treebank project
#ncluster_loader -U $UNAME -w $PWD -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.pos_tags pos_tags.csv
ncluster_loader -U ts186045 -w ts186045 -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.pos_tags pos_tags.csv
#ncluster_loader -U beehive -w beehive -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.pos_tags pos_tags.csv

#Counts the number of lines from the raw NHTSA complaints data
wc -l pos_tags.csv 


#Load the TREAD lookup table as agreed upon with the client
#ncluster_loader -U $UNAME -w $PWD -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.nhtsa_category_mapping tread_mapping.csv

ncluster_loader -U ts186045 -w ts186045 -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.nhtsa_category_mapping tread_mapping.csv
#ncluster_loader -U beehive -w beehive -d beehive --el-enabled --el-discard-errors --skip-rows 1 -c car_complaints.nhtsa_category_mapping tread_mapping.csv
