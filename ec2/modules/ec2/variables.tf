variable "type" {
    description = "Type instance"
    type        = string
}

variable "name" {
    description = "Name of the security group"
    type        = string
}

variable "description" {
    description = "Description of the security group"
    type        = string
}

variable "security_groups_ec2" {
    description = "Security group"
    type        = string
}

variable "environment" {
    description = "Environment of the security group"
    type        = string
}