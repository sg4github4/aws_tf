provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# Create VPC
resource "aws_vpc" "sgasik_vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "SGasik_VPC1"
  }
}

# Create Subnet
resource "aws_subnet" "sgasik_subnet1" {
  depends_on = [aws_vpc.sgasik_vpc1]
  vpc_id = "${aws_vpc.sgasik_vpc1.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "SGasik_Subnet1"
  }
}

# Create EC2

resource "aws_instance" "sgasik_ec2_1" {
  depends_on = [aws_vpc.sgasik_vpc1]
  ami = "ami-0e01ce4ee18447327"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.sgasik_subnet1.id}"

  tags = {
    Name = "SGasik_EC2_1"
  }
}
