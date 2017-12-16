#!/bin/bash
function extractworkflow(){
  psql -qAtX -d vmware -c "SELECT xmlcontent FROM vmo_workflowcontent WHERE workflowid = '$*'" > /tmp/workflow-content.temp
  VARFILENAME=$(cat /tmp/workflow-content | grep -o -P '(?<=CDATA\[).*(?=\]\])' |head -n 1 )
  VARFILENAME=${VARFILENAME// /_}
  VARFILENAME=$VARFILENAME$*
  zip -0 -j /tmp/$VARFILENAME.workflow /tmp/workflow-content /tmp/workflow-info /tmp/workflow-versionhistory
  echo "Generated file from workflow name $VARFILENAME with workflowID $*"
}
FILE=$1
while IFS=, read -r workflowid
do
TEMPNAME=$workflowid
extractworkflow $TEMPNAME
done < $FILE
