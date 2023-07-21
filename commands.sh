#deploy the application in region 1
serverless deploy --stage local --region us-east-1

awslocal route53 create-hosted-zone --name hello-localstack.com --caller-reference foo | jq -r .HostedZone.Id

/hostedzone/3YUH6FPPRU1BWE2


awslocal route53 create-health-check --caller-reference foobar --health-check-config '{
    "FullyQualifiedDomainName": "074c1168.execute-api.localhost.localstack.cloud",
    "Port": 4566,
    "ResourcePath": "/hello",
    "Type": "HTTPS",
    "RequestInterval": 10
}' | jq -r .HealthCheck.Id


aec1d2f4-299f-4f66-9b2a-da9236a46686


awslocal route53 change-resource-record-sets --hosted-zone ${HOSTED_ZONE_ID#/hostedzone/} --change-batch '{
"Changes": [
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "target1.'hello-localstack.com'",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [{"Value": "d307f0f9.execute-api.localhost.localstack.cloud"}]
        }
    },
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "target2.'hello-localstack.com'",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [{"Value": "7878dc86.execute-api.localhost.localstack.cloud"}]
        }
    }
]}'

awslocal route53 change-resource-record-sets --hosted-zone ${HOSTED_ZONE_ID#/hostedzone/} --change-batch '{
"Changes": [
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "target1.'$HOSTED_ZONE_NAME'",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [{"Value": "074c1168.execute-api.localhost.localstack.cloud"}]
        }
    },
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "target2.'$HOSTED_ZONE_NAME'",
            "Type": "CNAME",
            "TTL": 60,
            "ResourceRecords": [{"Value": "5ca511eb.execute-api.localhost.localstack.cloud"}]
        }
    }
]}'

/change/C2682N5HXP0BZ4

awslocal route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID#/hostedzone/} --change-batch '{
"Changes": [
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "test.hello-localstack.com",
            "Type": "CNAME",
            "SetIdentifier": "target1",
            "AliasTarget": {
                "HostedZoneId": "'${HOSTED_ZONE_ID#/hostedzone/}'",
                "DNSName": "target1.'hello-localstack.com'",
                "EvaluateTargetHealth": true
            },
            "HealthCheckId": "'54ece4d1-1b71-4653-b564-5cc84b4c6679'",
            "Failover": "PRIMARY"
        }
    },
    {
        "Action": "CREATE",
        "ResourceRecordSet": {
            "Name": "test.hello-localstack.com",
            "Type": "CNAME",
            "SetIdentifier": "target2",
            "AliasTarget": {
                "HostedZoneId": "'${HOSTED_ZONE_ID#/hostedzone/}'",
                "DNSName": "target2.'hello-localstack.com'",
                "EvaluateTargetHealth": true
            },
            "Failover": "SECONDARY"
        }
    }
]}'