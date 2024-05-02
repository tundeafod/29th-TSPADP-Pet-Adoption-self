#!/bin/bash
aws dynamodb create-table --table-name tspadp-backend --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region your region
echo "dynamo DB created"