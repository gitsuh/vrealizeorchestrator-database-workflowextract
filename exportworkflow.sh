#!/bin/bash
function extractworkflow(){
psql -d vmware -c "SELECT xmlcontent FROM vmo_workflowcontent WHERE workflowid = '$*'" > /tmp/recoveryattempt/tempfiles/workflow-content
sed -i 1d /tmp/recoveryattempt/tempfiles/workflow-content
sed -i 1d /tmp/recoveryattempt/tempfiles/workflow-content
sed -i 's/.$//' /tmp/recoveryattempt/tempfiles/workflow-content
VARFILENAME=$(cat /tmp/recoveryattempt/tempfiles/workflow-content | grep -o -P '(?<=CDATA\[).*(?=\]\])' |head -n 1 )
VARFILENAME=${VARFILENAME// /_}
VARFILENAME=$VARFILENAME$*
zip /tmp/recoveryattempt/finishedfile/$VARFILENAME.workflow /tmp/recoveryattempt/tempfiles/workflow-content /tmp/recoveryattempt/staticfiles/workflow-info /tmp/recoveryattempt/staticfiles/workflow-versionhistory
echo "Generated file from workflow name $VARFILENAME with workflowID $*"
}

FILE=$1
while IFS=, read -r workflowid
do
TEMPNAME=$workflowid
extractworkflow $TEMPNAME
done < $FILE
