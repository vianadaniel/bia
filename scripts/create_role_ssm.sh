role_name="role-access-ssm"
policy_name="AmazonSSMManagedInstanceCore"

if aws iam get-role --role-name "$role_name" &> /dev/null; then
    echo "An IAM role $role_name exist."
    exit 1
fi

aws iam create-role --role-name $role_name --assume-role-policy-document file://ec2_main.json
# Create profile
aws iam create-instance-profile --instance-profile-name $role_name

# Add an function IAM on profile of instance
aws iam add-role-to-instance-profile --instance-profile-name $role_name --role-name $role_name

aws iam attach-role-policy --role-name $role_name --policy-arn arn:aws:iam::aws:policy/$policy_name
