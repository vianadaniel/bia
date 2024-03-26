vpc_id=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[0].VpcId" --output text 2>/dev/null)
if [ $? -eq 0 ]; then
  echo "[OK] VPC"
else
  echo ">[ERROR] Default VPC"
fi

subnet_id=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$vpc_id Name=availabilityZone,Values=us-east-1a --query "Subnets[0].SubnetId" --output text 2>/dev/null)
if [ $? -eq 0 ]; then
  echo "[OK] Subnet"
else
  echo ">[ERROR] Subnet in zone A?"
fi

security_group_id=$(aws ec2 describe-security-groups --group-names "bia-dev" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)
if [ $? -eq 0 ]; then
  echo "[OK] Security Group bia-dev"

  # Validate security group 'bia-dev'
  inbound_rule=$(aws ec2 describe-security-groups --group-ids $security_group_id --filters "Name=ip-permission.from-port,Values=3001" --filters "Name=ip-permission.cidr,Values=0.0.0.0/0" --output text)

  if [ -n "$inbound_rule" ]; then
    echo " [OK] Inbound rule is correct"
  else
    echo " >[ERROR] Inbound rule for port 3001 not found or not open to the world. Review Henrylle's lesson."
  fi

  # Validate outbound rule for security group 'bia-dev'
  outbound_rule=$(aws ec2 describe-security-groups --group-ids $security_group_id --query "SecurityGroups[0].IpPermissionsEgress[?IpProtocol=='-1' && IpRanges[0].CidrIp=='0.0.0.0/0']" --output text)

  if [ -n "$outbound_rule" ]; then
    echo " [OK] Outbound rule is correct"
  else
    echo " >[ERROR] Outbound rule to the world not found. Review Henrylle's lesson."
  fi
else
  echo ">[ERROR] Security group bia-dev not found. Was it created?"
fi

if aws iam get-role --role-name role-access-ssm &>/dev/null; then
    echo "[OK] Everything is fine with the role 'role-access-ssm'"
else
    echo ">[ERROR] The role 'role-access-ssm' does not exist"
fi
