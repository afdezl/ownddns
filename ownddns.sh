#!/usr/bin/env bash

CURRENT_IP=$(curl -s curl ifconfig.co/)
LAST_IP_FILE=/tmp/lastip.txt
LAST_IP=''

HOSTED_ZONE_ID=$1
RECORD_NAME=$2


if [ -f $LAST_IP_FILE ]; then
	LAST_IP=$(cat $LAST_IP_FILE)
fi

echo -n $CURRENT_IP > $LAST_IP_FILE

if [ "$LAST_IP" = "$CURRENT_IP" ]; then
	echo 'Current public IP has not changed. Skipping update.'
else
	echo "Public IP has changed. Updating route53 record for ${TARGET_DOMAIN} with value ${CURRENT_IP}."
	aws route53 change-resource-record-sets --region eu-west-1 --profile ownddns --cli-input-json "$(cat <<EOF
{
    "HostedZoneId": "${HOSTED_ZONE_ID}",
    "ChangeBatch": {
        "Comment": "",
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "${RECORD_NAME}",
                    "Type": "A",
                    "TTL": 60,
		    "ResourceRecords": [
			{
				"Value": "${CURRENT_IP}"
			}
		    ]
                }
            }
        ]
    }
}
EOF
)"
fi

