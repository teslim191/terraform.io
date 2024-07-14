#define variables
variable "default_region" {
  default = "us-east-1"
}


variable "secondary_region" {
  default = "us-west-1"
}

variable "instance_type" {
  default = "t2.micro"
}

# variable "ami" {
#   default = "ami-04a81a99f5ec58529"
# }

variable "ami_ids" {
  type = map(string)
  default = {
    "us-east-1" = "ami-04a81a99f5ec58529"
    "us-west-1" = "ami-0ff591da048329e00"
  }
}

# providers
provider "aws" {
    region = var.default_region
}

provider "aws" {
  region = var.secondary_region
  alias = "secondary"
}

# resources
resource "aws_instance" "default_region_instance" {
    count = 3
    ami = var.ami_ids[var.default_region]
    instance_type =  var.instance_type 
    tags = {
      Name = "ubuntu"
    }
}

resource "aws_instance" "secondary_region_instance" {
  count = 2
  ami = var.ami_ids[var.secondary_region]
  instance_type = var.instance_type
  tags = {
    Name = "ubuntu"
  }
}

# create a vpc
# resource "aws_vpc" "my-first-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name= "production-vpc"
#   }
# }

#create a subnet
# resource "aws_subnet" "subnet_1" {
#   vpc_id = aws_vpc.my-first-vpc.id
#   availability_zone = "us-east-1a"
#   cidr_block = "10.0.1.0/24"
# }

#create an internet gateway
# resource "aws_internet_gateway" "prod_gateway" {
#   vpc_id = aws_vpc.my-first-vpc.id
#   tags = {
#     Name="Main-Gateway"
#   }
# }

#create a route table
# resource "aws_route_table" "prod-route-table" {
#   vpc_id =  aws_vpc.my-first-vpc.id
  
#   route {
#     # default route -- send all traffic (ip) to the internet gateway
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.prod_gateway.id
#   }

  # route {
  #   # default route for ipv6
  #   ipv6_cidr_block = "::/0"
  #   egress_only_gateway_id = aws_internet_gateway.prod_gateway.id
  # }

#   tags = {
#     Name= "production-route-table"
#   }
# }