resource "aws_vpc" "redcanary-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
        Name = "redcanary-vpc"
    }
}

resource "aws_subnet" "redcanary-subnet-public-1" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"

    tags = {
        Name = "redcanary-subnet-public-1"
    }
}

resource "aws_subnet" "redcanary-subnet-public-2" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"

    tags = {
        Name = "redcanary-subnet-public-2"
    }
}

resource "aws_subnet" "redcanary-subnet-private-1" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    cidr_block = "10.0.128.0/18"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"

    tags = {
        Name = "redcanary-subnet-private-1"
    }
    
}
resource "aws_subnet" "redcanary-subnet-private-2" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    cidr_block = "10.0.192.0/18"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"

    tags = {
        Name = "redcanary-subnet-private-2"
    }
}