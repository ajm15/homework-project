variable "AWS_REGION" {
    	default = "us-east-1"
	type = string
}
variable "UBUNTU_AMI" {
    default = "ami-0076b30a832c25ac4"
    type = string
}
//redacted access key! This must be replaced before execution!
variable "AWS_ACCESSKEY" {
	default = "ABC123DEF456GHI789"
	type = string
}
//redacted secret key! This must be replaced before execution!
variable "AWS_SECRETKEY" {
	default = "0987654321abcdefghijklmnop"
	type = string
}
