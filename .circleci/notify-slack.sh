#!/bin/sh

if [ -z $1 ] || [ -z $2 ]; then
  echo "Missing input parameters required to send Slack notifications. Aborting!"
  exit 1
fi

success=$1 # true or false
shift
message=${@}


if [ "$success" = "info" ]; then
  color="#3686A6"
elif [ "$success" = true ]; then
  color="#36a64f"
else
  color="#FF0000"
fi

# Set Slack data
slack_data='{"attachments": [{"fallback": "'${CIRCLE_PROJECT_REPONAME}' - '${message}'","color": "'${color}'","title": "['${CIRCLE_PROJECT_REPONAME}'] - '${message}'","title_link": "https://circleci.com/gh/Turistforeningen/'${CIRCLE_PROJECT_REPONAME}'/'${CIRCLE_BUILD_NUM}'","fields": [{"title": "CircleCI job","value": "'${CIRCLE_JOB}'","short": true},{"title": "Branch","value": "'${CIRCLE_BRANCH}'","short": true},{"title": "Workflow ID","value": "'${CIRCLE_WORKFLOW_ID}'","short": false}]}]}'

echo "sending slack notification ..."
curl -X POST $SLACK_WEBHOOK_CIRCLECI -H 'Content-type: application/json' --data "$slack_data"

if [ $? != 0 ]; then
  echo "Failed to send Slack notification!"
  exit 1
fi
