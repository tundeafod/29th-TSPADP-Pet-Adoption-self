#!/bin/bash
aws s3 rb s3://tfstate-tspadp --force
echo "bucket deleted"