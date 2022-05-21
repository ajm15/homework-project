resource "aws_launch_configuration" "app-servers-launch-config" {
    name_prefix = "app-"
    image_id = var.UBUNTU_AMI
    instance_type = "t2.micro"
    
    security_groups = ["${aws_security_group.private-app-sg.id}"]
    associate_public_ip_address = false

    //userdata section would go here, with instructions for installing/starting the service
    
    lifecycle {
        create_before_destroy = true
    }
}

//this autoscaling group is not configured with a scaling policy, only a min, max, and desired
//a more detailed scaling policy would be incorporated based on business requirements of this service
resource "aws_autoscaling_group" "app-servers-asg" {
    name = "app-servers-asg"

    min_size = 1
    desired_capacity = 2
    max_size = 2

    launch_configuration = "${aws_launch_configuration.app-servers-launch-config.name}"

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    vpc_zone_identifier = [
        aws_subnet.redcanary-subnet-private-1.id,
        aws_subnet.redcanary-subnet-private-2.id
    ]

    lifecycle {
        create_before_destroy = true
    }

    tag {
        key = "Name"
        value = "app-server"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_attachment" "app-servers-attach" {
    autoscaling_group_name = aws_autoscaling_group.app-servers-asg.id
    lb_target_group_arn = aws_lb_target_group.app-servers-tg.arn
}

output "alb_dns_name" {
        value = aws_alb.redcanary-public-alb.dns_name
    }