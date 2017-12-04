# Mongo Replica cluster 
Here you can find Terraform infrastructure files, ansible playbook, and tasks for deploying Mongo Replica cluster on Ubuntu in AWS. 
Create image from `Dockerfile` to make own image of MongoDB v3.4.


### Prerequisites

1. Install Terraform: `brew install terraform`
1. Install Ansible: `brew install ansible`
2. Install AWScli `brew install awscli`
1. Clone the repo: `git clone --recursive git@github.com:valch85/mongo_cluster.git`
2. Create AMI user with credentials (`aws_access_key_id` & `aws_secret_access_key`)
3. Put them into the file on your local machine `vim ~/.aws/credentials`

```bash
[default]
aws_access_key_id = 
aws_secret_access_key = 
```
7. Generate ssh keys `ssh-keygen -t rsa -C "mongo-tf" -f ~/.ssh/mongo-tf`
8. Copy keys to AWS `aws ec2 import-key-pair --key-name "mongo-tf" --public-key-material file://~/.ssh/mongo-tf.pub`

### Building Docker Images

To create Docker image go to folder `mongo_image`

```bash
cd mongo_image 
docker build -t mongo-3.4:v1 .
```
This image already built and pushed to Docker hub - valch85/mongo-3.4:v2

### Creating a new Mongo environment with Terraform
go to folder `mongo_tf`

```bash
cd mongo_tf 
terraform init
terraform plan
terraform apply
```
You will get 3 Ubuntu nodes (mongo-1a, mongo-1b, mongo-1c) in VPC in N.Virginia region in 3 different DC a, b & c correspondingly. Each server allocated on own dedicated subnet. Attached security group with open ports: 22 and 27017 for inbound connection and all ports for outbound. Each instance has DNS record in Route53 (depends on the variable domain_name in `variables.tf`). To each instance mounted 1Tb EBS volume in ext4 `/data` mount point. At the end you will get 3 IPs of newly created nodes, pls copy them to `../mongo_ansible/inventory_file`

### Applying an Ansible playbook to created nodes

```bash
cd mongo_ansible`
ansible-playbook -vvvv -uubuntu -i inventory_file playbook.yml --private-key=~/.ssh/mongo-tf
```

These will install Docker on the servers, deliver the docker-compose file, create system job to run it. Database files and logs saved to the host file system `/data/db` & `/data/logs`
