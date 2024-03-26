name="bia-dev"
instance_id=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag:Name,Values=$name" --output text)
aws ec2 stop-instances  --instance-ids $instance_id

if [ $? -eq 0 ]; then
  echo "[OK] Instance stopped"
  aws ec2 terminate-instances --instance-ids $instance_id
  if [ $? -eq 0 ]; then
    echo "[OK] Instance terminated"
  else
    echo ">[ERROR] Failed to terminate instance"
  fi
else
  echo ">[ERROR] Failed to stop instance"
fi
