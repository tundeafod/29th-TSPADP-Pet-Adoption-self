#!/bin/bash
aws dynamodb delete-table --table-name tspadp-backend --region eu-west-2
echo "table deleted"