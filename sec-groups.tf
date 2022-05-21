resource "aws_security_group" "public-alb-sg" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 443
        to_port = 443
        cidr_blocks = ["10.0.128.0/17"]
        protocol = "tcp"
    }

    tags = {
        Name = "public-alb-sg"
    }
}

resource "aws_security_group" "private-app-sg" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/23"]
    }

    egress {
        from_port = 443
        to_port = 443
        //this should be relegated to the CIDRs of the third party API endpoints only for best security
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    tags = {
        Name = "private-app-sg"
    }
}