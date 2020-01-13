

#!/bin/bash

#To give to process name
#PROCESS=$1
procheck()
{
read -p "Enter the process name : " process_name
procount=`ps -ef | grep -i $process_name | grep -v grep|wc -l`
if [ "$procount" == 0 ]
then
echo "There is no process called $process_name exist on server `uname -n`"
exit 1
else
echo "Process $process_name is exist on server `uname -n`"
fi
}

procheck

#Login to the server
echo -e "Setting up session"
read -s -p "Enter password : " SSHPASS
export SSHPASS


#Collect the process Ids of process

sshpass -e ssh -q -o ConnectTimeout=30 -o 'StrictHostKeyChecking no' -T root@localhost 'bash -s' << 'ENDSSH'

pid1="pgrep -x $process_name"

pid3=$pid1
echo -e "\ncollected process ids for $process_name"

echo -e "\ncheking the state of process"

#Comparing the process id file after 20 secs
sleep 20
pid4=$pid1
if [ "$pid3" == "$pid4" ];
  then
    echo -e "\nProcess is in hung state"
  else
    echo -e "\nProcess is working fine"
fi

ENDSSH






