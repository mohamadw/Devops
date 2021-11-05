# AWS Terraform

##  
![image](https://github.com/mohamadw/Devops/blob/aws_terraform/image1.png?raw=true)
- 2 Instances (t2.micro) - with NGINX running on each.

- An Application Load Balancer that forwards the users’ traffic to the servers

## Prerequesties
1. IAM user.
2. terraform.


## Run The app:
    terraform init
    terraform apply(after that enter your access key & secretKey).

## verify everything:
1. Sign in to your amazon account in the Console. 
2. Go to the load balancer, in EC2.
3. Copy DNS name of the Load Balancer to your Browser.
