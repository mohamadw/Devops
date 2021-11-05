terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
    region = var.region
    access_key = var.accessKey
    secret_key = var.secretKey
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count
  user_data     =  file("nginx.sh")

  tags = {
    Name  = element(var.instance_tags, count.index)
  }
}

# choosing  the default vpc
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

data "aws_internet_gateway" "my_gtw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}


resource "aws_security_group" "allow_web" {
  name = "allow_web_terraform"

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "All networks allowed"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    "Name" = "terraform-assignment"
  }

}




resource "aws_lb_target_group" "my_tg" {
  name     = "terraform-loadBalancer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
}

resource "aws_alb_target_group_attachment" "test" {
  count = length(aws_instance.my_instance) # taken from https://stackoverflow.com/questions/44491994/not-able-to-add-multiple-target-id-inside-targer-group-using-terraform
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id = aws_instance.my_instance[count.index].id
  port = 80
}

# create a load balancer
resource "aws_lb" "assignment_lb" {
  name               = "lb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = data.aws_subnet_ids.default_subnet.ids

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "my_aws_lb_listener" {
  load_balancer_arn = aws_lb.assignment_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}