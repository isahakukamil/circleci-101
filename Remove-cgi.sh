echo "************************************************************"
echo "**********Script to Remove cgi scripts on IN nodes**********"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"


rm /var/apache/cgi-bin/printenv
status="$?"
if [[ $status="0" ]]
then
	echo "Printenv cgi scripts removed successfully"
elif [[ $status="1" ]]
then
	echo "Failed to remove Printenv cgi script"
else
	echo "exit status=$status"
fi
rm /var/apache/cgi-nin/test-cgi
status="$?"
if [[ $status="0" ]]
then
        echo "test-cgi cgi scripts removed successfully"
elif [[ $status="1" ]]
then
        echo "Failed to remove test-cgi script"
else
        echo "exit status=$status"
fi

