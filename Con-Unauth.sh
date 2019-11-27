echo ":********************************************************************"
echo "Script to Restrict Concurrent Unauthenticated User Access on IN nodes"
echo "***************Name:Issahaku Kamil | UserID : EKAMISS****************"
echo "*********************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

if grep -Fxq "SSHConfiBack" /tmp
then

        echo "Backup of /etc/ssh/sshd_config is stored in  /tmp/SSHConfigBack directory"


else
	mkdir /tmp/SSHConfigBack
        echo "...Backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfigBack directory..."
fi

#Extract Timestamp
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo "............................................................."
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo "............................................................."
touch /tmp/SSHConfigBack/RootConfigBackup.$ExtrTimeStamp;
cp -r /etc/ssh/sshd_config /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp

#Set MaxAuthTries to 4
sed -i -e 's/.*MaxAuthTries/MaxAuthTries 4/g;'  /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo ".....The maximum number of authentication retries is set to 4....."
elif [[ $status="1" ]]
then
        echo "....Could not set password max auth tries..."
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
        echo "...........Rollback Initiated..........."
else
        echo "exit status=$status"
fi

#Set MaxSessions to 10
sed -i -e 's/.*MaxSessions.*/MaxSessions 10/g;' /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo ".....The maximum number of SSH Sessions is set to 10.............."
elif [[ $status="1" ]]
then
        echo ".......Could not set  max sessions.........."
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

#Set MaxStartups to 11
sed -i -e 's/.* MaxStartups .*/MaxStartups 11/g;' /etc/ssh/sshd_config
status="$?"
if [[ $status="0" ]]
then
        echo ".....The maximum number of concurrent unauthenticated sessions is set to 11....."
elif [[ $status="1" ]]
then
        echo "....Could not set password max startups....."
        cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp /etc/ssh/sshd_config
        echo "........................................"
        echo "...........Rollback Initiated..........."
        echo "........................................"
else
        echo "exit status=$status"
fi

#Restart SSH SERVICE
systemctl restart sshd;
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





























