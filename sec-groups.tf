//SG to be applied to public-facing ALB
resource "aws_security_group" "public-alb-sg" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    //allowing ingress from public internet over TCP/443
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    //allowing egress to TCP/443 with destination of private subnets
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

//SG to be applied to internal application servers
resource "aws_security_group" "private-app-sg" {
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    //allowing ingress over TCP/443 from the public subnet
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/23"]
    }

    //allowing egress to TCP/443 with destination of anywhere
    //this should be tightened up by specifying the numerical IP space of the externally accessed API services
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
