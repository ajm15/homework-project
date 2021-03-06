//creatings an internet gateway
resource "aws_internet_gateway" "redcanary-igw" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    tags = {
        Name = "redcanary-igw"
    }
}

//public subnet routing table sending all traffic to IGW
resource "aws_route_table" "public-rtb" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.redcanary-igw.id}"
    }

    tags = {
        Name = "public-rtb"
    }
}

//route table associations with respective subnets
resource "aws_route_table_association" "redcanary-subnet-public-1" {
    subnet_id = "${aws_subnet.redcanary-subnet-public-1.id}"
    route_table_id = "${aws_route_table.public-rtb.id}"
}

resource "aws_route_table_association" "redcanary-subnet-public-2" {
    subnet_id = "${aws_subnet.redcanary-subnet-public-2.id}"
    route_table_id = "${aws_route_table.public-rtb.id}"
}

//allocating public IPs for the NAT Gateways
resource "aws_eip" "nat_gateway01-eip" {
    vpc = true
}

resource "aws_eip" "nat_gateway02-eip" {
    vpc = true
}

//creating a pair of NAT gateways - one for each of two Availability Zones
resource "aws_nat_gateway" "nat_gateway-01" {
    allocation_id = "${aws_eip.nat_gateway01-eip.id}"
    subnet_id = "${aws_subnet.redcanary-subnet-public-1.id}"

    tags = {
        "Name" = "nat_gateway-01"
    }
}

resource "aws_nat_gateway" "nat_gateway-02" {
    allocation_id = "${aws_eip.nat_gateway02-eip.id}"
    subnet_id = "${aws_subnet.redcanary-subnet-public-2.id}"

    tags = {
        "Name" = "nat_gateway-02"
    }
}

//create and associate route tables for the private subnets creating a default route to their respective NAT-GW
resource "aws_route_table" "private-rtb-1" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gateway-01.id}"
    }
}

resource "aws_route_table" "private-rtb-2" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gateway-02.id}"
    }
}

resource "aws_route_table_association" "private-subnet-association-01" {
   subnet_id = "${aws_subnet.redcanary-subnet-private-1.id}"
   route_table_id = "${aws_route_table.private-rtb-1.id}"
}

resource "aws_route_table_association" "private-subnet-association-02" {
   subnet_id = "${aws_subnet.redcanary-subnet-private-2.id}"
   route_table_id = "${aws_route_table.private-rtb-2.id}"
}
