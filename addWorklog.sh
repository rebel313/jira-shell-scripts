#! /bin/bash


# Make sure a jiraissues.csv file is available
# Format of the file should be like this
# 02/06/2021,KEY-1,2h 30m,I did this
# Just run the script

while read line
do
     issuekey="$(echo $line | cut -d ',' -f 2)"
     worklog="$(echo $line | cut -d ',' -f 3)"
     d="$(echo $line | cut -d ',' -f 1)"
     comment="$(echo $line | cut -d ',' -f 4)"

     day=$(echo $d | cut -d '/' -f 1)
     month=$(echo $d | cut -d '/' -f 2)
     year=$(echo $d | cut -d '/' -f 3)

echo "$d $issuekey $worklog"
     curl -S -X POST \
          -H "Authorization:Basic $JIRATUTORIAL_AUTH" \
          -H "Content-Type:application/json" \
        https://pepsa.atlassian.net/rest/api/3/issue/$issuekey/worklog \
        -o work.txt --progress-bar \
          -d \
          '{
    "timeSpent": "'"$worklog"'",
    "started": "'$year'-'$month'-0'$day'T08:00:00.751+0000",
    "comment": {
        "type": "doc",
        "version": 1,
        "content": [
      {
        "type": "paragraph",
        "content": [
          {
            "text": "'"$comment"'",
            "type": "text"
          }
        ]
      }
    ]
  }
     }'
     sleep .5
done < jiraissues.csv

exit
