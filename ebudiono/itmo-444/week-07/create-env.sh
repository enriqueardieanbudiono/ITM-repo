#!/bin/bash

VPCID=$(aws ec2 describe-vpcs --output=text --query='Vpcs[*].VpcId')

# Wait for EC2
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/wait/instance-running.html
aws ec2 run-instances --image-id $1 --instance-type $2 --key-name $3 --security-group-ids $4 --user-data file://install-env.sh --no-cli-pager


aws elbv2 create-target-group \
    --name $8 \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id $VPCID \
    --no-cli-pager

# Create Load Balancer

SUBNET1=$(aws ec2 describe-subnets --output=text --query 'Subnets[0].SubnetId')
SUBNET2=$(aws ec2 describe-subnets --output=text --query 'Subnets[1].SubnetId')
aws elbv2 create-load-balancer \
    --name $7 \
    --subnets $SUBNET1 $SUBNET2 \
    --security-groups $4 \
    --no-cli-pager

# Create Listener
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/create-listener.html

CLI=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].LoadBalancerArn')
TG=$(aws elbv2 describe-target-groups --output=text --query='TargetGroups[*].TargetGroupArn')

aws elbv2 wait load-balancer-available \
    --load-balancer-arns $CLI \
    --no-cli-pager

aws elbv2 create-listener \
    --load-balancer-arn $CLI \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TG \
    --no-cli-pager

# Connect the Instances with Target Group

IDS=$(aws ec2 describe-instances --output=text --query='Reservations[*].Instances[*].InstanceId' --filters Name=instance-state-name,Values=running)

aws elbv2 register-targets \
    --target-group-arn $TG \
    --targets Id=$IDS \
    --no-cli-pager

# aws elbv2 describe-load-balancers -- retrieve the URL

URL=$(aws elbv2 describe-load-balancers --output=text --query='LoadBalancers[*].DNSName')

echo 'URL ===> ' $URL