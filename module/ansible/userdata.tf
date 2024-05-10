locals {
  ansible-user-data = <<-EOF
#!/bin/bash
#Update instance and install tools (get, unzip, aws cli) 
sudo yum update -y
sudo yum install wget -y
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws /usr/bin/aws #This command is often used to make the AWS Command Line Interface (AWS CLI) available globally by creating a symbolic link in a directory that is included in the system's PATH
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'
#configuring awscli on the ansible server
sudo su -c "aws configure set aws_access_key_id ${aws_iam_access_key.ansible_user_key.id}" ec2-user
sudo su -c "aws configure set aws_secret_access_key ${aws_iam_access_key.ansible_user_key.secret}" ec2-user
sudo su -c "aws configure set default.region eu-west-3" ec2-user
sudo su -c "aws configure set default.output text" ec2-user

# Set Access_keys as ENV Variables
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.ansible_user_key.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.ansible_user_key.secret}

# install ansible
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum install python python-devel python-pip ansible -y
sudo hostnamectl set-hostname Ansible
EOF
}