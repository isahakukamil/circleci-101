file=/etc/ssh/sshd_config
echo ""
echo "Enter yes/no to either permit or deny Root Login"
echo ""
read permit
if [[$permit -eq "yes"]]
then
        sed -i 's/.*PermitRootLogin.*/PermitRootLogin '$permit'/g' $file
        status=`echo "$?"`
        if [[ "$status" == 0 ]]
        then
                echo "PermitRootLogin is set to yes"
        elif [[ "$status" == 1 ]]
        then
                echo "Failed to set  PermitRootLogin to yes"
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
                echo "PermitRootLogin is set to no"
        elif [[ $status="1" ]]
        then
                echo "Failed to set  PermitRootLogin to no"
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo "exit status=$status, Please try again"
        fi
else
        echo "Please set either yes/no to continue"

fi

