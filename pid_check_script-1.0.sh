#!/bin/bash

#To give to process name
#PROCESS=$1
procheck()
{
read -p "Enter the process name : " process_name
procount=`ps -ef | grep -i $process_name | grep -v grep|wc -l`
if [ "$procount" == 0 ]
then
echo "There is no process called $process_name exist on server `uname -n`.Please provide a valid process name"
exit 1
else
echo "Process $process_name is exist on server `uname -n`"
fi
}

procheck

#Login to the server
echo -e "\nSetting up session"
echo -e "---------------------\n"
read -s -p "Enter password : " SSHPASS
export SSHPASS


#Collect the process Ids of process
echo " "
for i in `cat file`
do
sshpass -e ssh -q -o ConnectTimeout=30 -o 'StrictHostKeyChecking no' -T root@$i PROC="${process_name}" 'bash -s' << 'ENDSSH'

pid1="pgrep -x $PROC"

pid3=$pid1
echo -e "\ncollected process ids for $PROC on `uname -n`"

echo -e "\nchecking the state of $PROC process....."

#Comparing the process id file after 20 secs
sleep 20
pid4=$pid1
if [ "$pid3" == "$pid4" ];
  then
    echo -e "\n\e[1;31mProcess $PROC is in hung state on `uname -n`\e[0m"
  else
    echo -e "\n\e[1;31mProcess $PROC is working fine on `uname -n`e[0m"
fi

ENDSSH
done