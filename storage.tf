//create an S3 bucket to store ALB logs
resource "aws_s3_bucket" "alb-logs-s3" {
    bucket = "amiko-alb-logs-s3"
     
    tags = {
        Name = "amiko-alb-logs-s3"
        Environment = "Prod"
    }
}

//ensure the S3 bucket is kept private
resource "aws_s3_bucket_acl" "alb-logs-s3-acl" {
    bucket = aws_s3_bucket.alb-logs-s3.id
    acl = "private"
}

//actively block pulic access to or from the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3-block-public" {
    bucket = aws_s3_bucket.alb-logs-s3.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls =  true
    restrict_public_buckets = true
}
