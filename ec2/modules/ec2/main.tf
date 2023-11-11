resource "aws_instance" "ec2" {
    ami           = "ami-0fb653ca2d3203ac1"
    instance_type = var.type
    security_groups = [var.security_groups_ec2]
    tags = {
        Name        = var.name
        Environment = var.environment
    }
}