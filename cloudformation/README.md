# AWS

## EC2 Subscription
One of the processes that cannot be automated yet, is to register to the
subscriptions of the Linux distributions, that needs to be done manually before
to start using them on CloudFormation.

The 2 main distributions are:
* Ubuntu 24.04 LTS:
https://aws.amazon.com/marketplace/server/procurement?productId=prod-ib2w5aw4ynhey

* Rocky Linux 9:
https://aws.amazon.com/marketplace/server/procurement?productId=3f230a17-9877-4b16-aa5e-b1ff34ab206b

Once accepted the subscription they will show up in the Marketplace's dashboard:
https://us-east-1.console.aws.amazon.com/marketplace?region=us-east-1#/subscriptions

## Available EC2 AMIs
To call the proper AMI on each region we need to map them on the CloudFormation template,
and they can be listed with the following command:
```
for REGION in us-east-1 us-west-2; do
        echo "REGION: ${REGION}"
        aws ec2 describe-images \
                --owners aws-marketplace \
            --filters Name=product-code,Values=3qk9e6x2ni81uiqnorll45r3f \
                --query 'Images[*].[CreationDate,Name,ImageId]' \
                --filters "Name=name,Values=${DISTRO_NAME} ${DISTRO_VERSION}*" \
                --region ${REGION} \
                --output table
done
```

Where the variables in the `--filters` flag are:
* `${DISTRO_NAME}` is the name of the Linux Distribution, ie: Ubuntu or Rocky
* `${DISTRO_VERSION}` is the desired version, ie: 24 or 9 respectively.
Notice that the wilcard after the version number will do the rest of the work.
