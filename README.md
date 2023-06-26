# OWNDDNS

Simple script to update a Route53 record when the machine's public address changes.

## Prerequisites

- IAM user with at least the following permission (replace `HOSTED_ZONE_ID`)`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/<HOSTED_ZONE_ID>"
        }
    ]
}
```

- Local aws cli installed with a profile called ownddns.


## Usage

```shell
./ownddns.sh <HOSTED_ZONE_ID> <RECORD_SET>
```

### Cronjob setup

Example (run every five minutes):

```shell
*/5 * * * * /home/pi/ownddns.sh ZZZ0D1ZW2ZTOP ip.example.com
```
