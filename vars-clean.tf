variable "AWS_REGION" {
    default = "us-east-1"
}
variable "UBUNTU_AMI" {
    default = "ami-0076b30a832c25ac4"
    type = string
}
variable "AWS_ACCESSKEY" {
	default = "ABC123DEF456GHI789"
    type = string
}
variable "AWS_SECRETKEY {
	default = "0987654321abcdefghijklmnop"
	type = string
}