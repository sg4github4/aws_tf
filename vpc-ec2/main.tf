provider "aws" {
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#Create VPC
resource "aws_vpc" "sgasik_vpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "SGasik_VPC1"
  }
}

#Create Subnet
resource "aws_subnet" "sgasik_subnet1" {
  depends_on = [aws_vpc.sgasik_vpc1]
  vpc_id = "${aws_vpc.sgasik_vpc1.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "SGasik_Subnet1"
  }
}

#Create EC2
resource "aws_instance" "sgasik_ec2_1" {
  depends_on = [aws_vpc.sgasik_vpc1]
  ami = "ami-0e01ce4ee18447327"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.sgasik_subnet1.id}"

  tags = {
    Name = "SGasik_EC2_1"
  }
}

#Create S3 bucket
resource "aws_s3_bucket" "sgasiks3bucket1" {
bucket = "sgasiks3bucket1"
acl    = "private"
}

#Create Athena Database
resource "aws_athena_database" "sgasiks3bucket1" {
  name = "sgasik_athenadb"
  bucket = "${aws_s3_bucket.sgasiks3bucket1.bucket}"
}

#Create Athena Work Group
resource "aws_athena_workgroup" "sgasik_AthenaWG1" {
  name = "sgasik_AthenaWG1"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://{aws_s3_bucket.sgasik_AthenaWG1.bucket}/output/"

      #encryption_configuration {
      #  encryption_option = "SSE_KMS"
      #  kms_key_arn       = "${aws_kms_key.sgasik_AthenaWG1.arn}"
      #}
    }
  }
}
