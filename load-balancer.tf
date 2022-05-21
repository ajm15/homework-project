//creates a listener rule, this is a place holder and would need to be updated prior to production
resource "aws_alb_listener_rule" "static" {
    listener_arn = "${aws_alb_listener.public-https-listener.arn}"
    priority = 100

    action {
        type = "forward"
        target_group_arn = "${aws_lb_target_group.app-servers-tg.arn}"
    }

    condition {
        host_header {
            values = ["service.redcanary.com"]
        }
    }
}

//creates an AWS ALB
resource "aws_alb" "redcanary-public-alb" {
    name = "redcanary-public"
    internal = "false"
    load_balancer_type = "application"
    security_groups = [aws_security_group.public-alb-sg.id]
    subnets = ["${aws_subnet.redcanary-subnet-public-1.id}","${aws_subnet.redcanary-subnet-public-2.id}"]

//access logs are sent to a specified S3 bucket
  access_logs {    
    bucket = "${aws_s3_bucket.alb-logs-s3.id}"
    prefix = "ELB-logs"  
  }

    tags = {
        Name = "redcanary-public-alb"
    }
}

//creates target group to associate with ALB
resource "aws_lb_target_group" "app-servers-tg" {
    name = "app-servers-tg"
    port = 443
    protocol = "HTTPS"
    vpc_id = "${aws_vpc.redcanary-vpc.id}"

    health_check {
      healthy_threshold = 5
      unhealthy_threshold = 4
      timeout = 5
      interval = 10
      port = 443
      //path is incorrect, would need to be set to something valid
      path = "/api/somepath/default?path=/service/my-service"
    }
}

//creates an ALB listener with a dummy certificate
//this will have to be changed to a real certificate prior to production deployment
resource "aws_alb_listener" "public-https-listener" {
    load_balancer_arn = "${aws_alb.redcanary-public-alb.arn}"
    port = "443"
    protocol = "HTTPS"
     
    ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
    //ssl policy might need redefined based on business polices
    
    certificate_arn = "arn:aws:acm:us-east-1:938155829106:certificate/1422c79a-7ed4-424f-ae8e-9ee00675d167"
    //certificate is a dummy for testing only, needs replacing for production!
    
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app-servers-tg.arn
    }
}
