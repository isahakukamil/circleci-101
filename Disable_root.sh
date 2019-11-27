#!/bin/bash
echo "************************************************************"
echo "*****Script to Disable Root Access via SSH on IN nodes******"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

file=/etc/ssh/sshd_config
if grep -Fxq "SSHConfigBack" /tmp
then
	echo ""
	echo "The backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfigBack directory...."
	echo ""

else
	mkdir /tmp/SSHConfigBack/
	echo ""
fi

if grep -Fxq "Disable_root_logs" /var/log
then 
	echo ""
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo ""
else
	mkdir /var/log/Disable_root_logs
	echo ""
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo ""
fi
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S");
echo ""
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ""

touch /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;
cp -r $file /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;

#Set the securetty file to empty to prevent direct login from any device
echo > /etc/securetty;
status="$?"
if [[ $status = "0" ]]
then
	echo ""
	echo "Securetty File has been cleared to Direct login via any device"
	echo ""
elif [[ $status = "1" ]]
then 
	echo ""
	echo "Clearing of securetty file has not been successful"
	echo ""
else
	echo ""
	echo "Exit status=$status"
	echo ""
fi

#Permit or Deny Root Login
file=/etc/ssh/sshd_config
echo ""
echo "Enter yes/no to either permit or deny Root Login"
echo ""
read permit

if [[ $permit -eq "yes" ]]
then
        sed -i 's/.*PermitRootLogin.*/PermitRootLogin '$permit'/g' $file
        status="$?"
        if [[ $status="0" ]]
        then
                echo "PermitRootLogin is set to $permit"
        elif [[ $status="1" ]]
        then
                echo "Failed to set  PermitRootLogin to $permit"
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo "exit status=$status, Please try again"
        fi
elif [[ $permit -eq "no" ]]
then
        sed -i 's/.*PermitRootLogin.*/PermitRootLogin '$permit'/g' $file
        status="$?"
        if [[ $status="0" ]]
        then
               echo "PermitRootLogin is set to $permit"
        elif [[ $status="1" ]]
        then
                echo "Failed to set  PermitRootLogin to $permit"
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo "exit status=$status, Please try again"
        fi
else
        echo "Please set either yes/no to continue"
fi

#Configure SSH Session Timeout
echo ""
echo "You are required to set the SSH timeout for an ongoing SSH session."
echo "Please enter the required value for the SSH timeout."
read timout
echo "Do you want to set the SSH timeout value to $timout seconds? yes/no"
echo ""
read ans

if [[ $ans -eq "yes" ]]
then
        sed -i 's/.*ClientAliveInterval.*/ClientAliveInterval '$timout' /g' $file
        if [[ $status =  "0" ]]
	then
		echo ""     
		echo "ClientAliveInterval is set to '$timout' seconds"
        	echo ""
	elif [[ $status = "1" ]]
	then
        #Rollback if the action is not successful
        	echo ""
       	        echo "Failed to set ClientAliveInterval,please try again :-)"
                echo ""
		cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
	else
        	echo ""
        	echo "exit status=$status"
        	echo ""
	fi

elif [[ $ans -eq "no" ]]
then
	echo ""
        echo "No value set for SSH timeout"
	echo ""
else
        echo "Please enter either yes or no"
fi

#Set ClientAliveCountMax
echo ""
echo "You are required to enter the value for the Duration of an Alive Client SSH Session"
echo ""
read count
echo ""
echo "Do you want to set $count as the Client Alive Count? yes/no"
echo ""
read alive
if [[ $alive -eq "yes" ]]
then
	sed -i 's/.*ClientAliveCountMax.*/ClientAliveCountMax '$count'/g' $file
	#Check if Action was successful
	if [[ $status =  "0" ]]
	then
        	echo ""
        	echo "ClientAliveCountMax is set to $count seconds"
        	echo ""
	elif [[ $status = "1" ]]
	then
       	        #Rollback if the action is not successful
        	echo ""
       	        echo "Failed to set ClientAliveCountMax,please try again :-)"
        	echo ""
	        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
	else
        	echo ""
        	echo "exit status=$status"
       	        echo ""
	fi
elif [[ $alive -eq "no" ]]
then
	echo ""
	echo "ClientAliveCount has not been set"
	echo ""
else
	echo "Please enter yes/no to continue"
fi

#Set X11Forwarding to "yes"
sed -i 's/.*X11Forwarding .*/X11Forwarding yes/g;' $file
#Check if Action was successful
        if [[ $status =  "0" ]]
        then
                echo ""
                echo "X11fForwarding has been set to yes"
                echo ""
        elif [[ $status = "1" ]]
        then
                #Rollback if the action is not successful
                echo ""
                echo "Failed to set X11Forwarding to yes,please try again :-)"
                echo ""
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo ""
                echo "exit status=$status"
                echo ""
        fi

systemctl restart sshd
#Check if Action was successful
if [[ $status =  "0" ]]
then
        echo "..................................."
        echo "SSH has been Restarted Successfully"
        echo "..................................."
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "........................................................"
        echo "<<<<<<<<<<<<Failed to Restart SSH..Trying again>>>>>>>>>"
        echo "........................................................"
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi


