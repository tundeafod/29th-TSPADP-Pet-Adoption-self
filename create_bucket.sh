#!/bin/bash
aws s3api create-bucket --bucket tfstate-tspadp --region eu-west-2 --create-bucket-configuration LocationConstraint=eu-west-2
echo "bucket created"