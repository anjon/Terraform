3. Terraform file
As we are already aware that terraform is a command line tool for creating, updating and versioning infrastructure in the cloud then obviously we want to know how does it do so? Terraform describes infrastructure in a file using the language called Hashicorp Configuration Language (HCL) with the extension of .tf It is a declarative language that describes infrastructure in the cloud. When we write our infrastructure using HCL in .tf file, terraform generates an execution plan that describes what it will do to reach the desired state. Once execution plan is ready, terraform executes the plan and generates a state file by the name terraform.tfstate by default. This file maps resource meta data to the actual resource ID and lets terraform knows what it is managing in the cloud.

4. Terraform and provision AWS
To deploy an EC2 instance through terraform create a file with extension .tf This file contains namely two section. The first section declares the provider (in our case it is AWS). In provider section we will specify the access key and secret key that is written in the CSV file which we have downloaded earlier while creating EC2 user. Also choose the region of your choice. The resource block defines what resources we want to create. Since we want to create EC2 instance therefore we specified with "aws instance" and the instance attributes inside it like ami, instance type and tags.
vi aws.tf

provider "aws" {
access_key = "ZKIAITH7YUGAZZIYYSZA"
secret_key = "UlNapYqUCg2m4MDPT9Tlq+64BWnITspR93fMNc0Y"
region = "ap-southeast-1"
}

resource "aws_instance" "example" {
ami = "ami-83a713e0"
instance_type = "t2.micro"
tags {
Name = "your-instance"
}
}

Apply terraform plan first to find out what terraform will do. The terraform plan will let us know what changes, additions and deletions will be done to the infrastructure before actually applying it. The resources with '+' sign are going to be created, resources with '-' sign are going to be deleted and resources with '~' sign are going to be modified.

terraform init
terraform plan
terraform apply

5. A more complex terraform example

Now that, we have understood how to create an EC2 instance using terraform, let us create a bit more advance infrastructure using terraform. Our infrastructure aim includes-

→ Creating a VPC with CIDR 10.0.0.0/16

→ A public subnet inside VPC with CIDR 10.0.1.0/24

→ A private subnet inside VPC with CIDR 10.0.2.0/24

→ Security groups for both public and private instances

→ Three EC2 instances- Web server, Database server and NAT instance

First, We create a key pair by the name linoxide-deployer.pem through AWS console. To do that, click "Key-pairs" from EC2 dashboard followed by "Create Key Pair" and save it in a newly created directory inside terraform folder that we have created in step 4.

Download and copy linoxide-deployer.pem inside ~/terraform/ssh directory.

Now, We start creating resources one by one starting from VPC. Also we will split the configuration into several .tf files based on what they does. e.g for creating VPC resource, we will create a file by the name vpc.tf so that we can keep track of what each file does. Before creating resources, let us declare all variables in variables.tf file.

Let us define VPC with CIDR block of 10.0.0.0/16 [vpc.tf]
Define the gateway [gateway.tf]
Define public subnet with CIDR 10.0.1.0/24 [public.tf]
Define private subnet with CIDR 10.0.2.0/24 [private.tf]
Route table for public/private subnet [route.tf]
Define NAT security group [natsg.tf]
Define security group for Web [websg.tf]
Define security group for database in private subnet [dbsg.tf]
Define web-server instance [webserver.tf]
Define DB instance [dbinstance.tf]
Define NAT instance [natinstance.tf]
Allocate EIP for NAT and Web instance [eip.tf]

Execute terraform plan first to find out what terraform will do. You can also make a final recheck of your infrastructure before executing terraform apply. There are total 16 plans to be added, nothing to change or destroy.
terraform plan

Now execute terraform apply
terraform apply

Once the execution of above command completed, our infrastructure will come alive with one VPC, two subnet, Gateway, routing tables, security groups, EIP association, all the three EC2 instances etc. You will have all the 16 resources. You can create the infrastructure graph using the following command.
terraform graph | dot -Tpng > infrastructure_graph.png

Now connect to NAT instance from your local workstation, you will be inside the NAT instance. The private IP allocated to NAT instance in our infrastructure is 10.0.1.220.  Access the instance inside private subnet i.e DB instance through NAT instance as well as 'Web Server LAMP' instance. The private IP allocated to DB and Web server instances are 10.0.2.220 and 10.0.1.207 respectively. Browse EC2 dashboard to find the private IP allocated to your instances.
ssh -i "./ssh/linoxide-deployer.pem" ec2-user@ec2-52-220-223-173.ap-southeast-1.compute.amazonaws.com

Ping DB instance from NAT, Ping Web server instance from NAT
ping 10.0.2.220
ping 10.0.1.207


