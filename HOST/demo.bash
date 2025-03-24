#!/bin/sh
##==================================================================================================================================
##PROGRAM         :XXQGEN_DEMO_HOST
##TYPE            :
##UNIX LOCATION   :/u01/XXQGEN/fs1/EBSapps/appl/XXQGEN/12.0.0/bin  ** This UNIX Location is for XXQGEN **
##
##
##INSERTS INTO    :XX
##CALLED BY       :
##
##==================================================================================================================================
##DESCRIPTION:
##
##   This is the Host file used by Concurrent Program to Upload CSV File data FROM the directory into the XX Database
##   table. It is called by the " " Concurrent Program.
##
##   The " "  will then be run to Load FS Setup Customer,Job Type,City-State,Market values 
##
##==================================================================================================================================
##PRE-REQUISITES:
##
##   DEMO PROGRAM
##
##==================================================================================================================================
##HISTORY:
##
##  WHEN      	  PROGRAMMER         SNOW REQ#    SNOW CHG#   STAT CSR  DESCRIPTION
##  --------- 	  -----------------  -----------  ----------  --------  ----------------------------------------------------------------
##  
##==================================================================================================================================

#######################################################
#                                                     #
#              FUNCTION - DATALOAD                    #
#                                                     # 
#######################################################



sqlldr userid=$P_LOGIN control=$CTL_FILE log=$LOG_FILE data=$DATA_FILE bad=$BAD_FILE discard=$DIS_FILE

echo "SQL*Loader execution successful" 

cp $DATA_FILE $ARCH_FILE
rm $DATA_FILE

echo "The data file has been copied successfully to the Archive Directory."

}

#################################################
#                                               #
#                    M A I N                    #
#                                               #
#################################################
#                                               #
#            Program Starts From Here           #
#                                               #
#################################################

echo "Setting Parameters"

P_LOGIN=`echo $1 | cut -f2 -d '"'`
P_USERNAME=`echo $P_LOGIN | cut -f1 -d '/'`
P_REQID=`echo $1 | cut -f2 -d " " | cut -f2 -d "="`
CTL_DIR=`echo $1 | cut -f8 -d '"'`
CSV_DIR=`echo $1 | cut -f10 -d '"'`
REQUEST_ID=`echo $1 | cut -f12 -d '"'`

 echo "$P_LOGIN"

 echo "Script to copy the data from flat file to the FS Setup Mapping interface table. \n"