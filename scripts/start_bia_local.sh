name="bia-dev"
instance_id=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag:Name,Values=$name" --output text)
aws ec2 start-instances  --instance-ids $instance_id
