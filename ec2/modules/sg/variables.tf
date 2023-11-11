variable "vpc_id" {
    description = "VPC id of the security group"
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

variable "environment" {
    description = "Environment of the security group"
    type        = string
}

variable "ingress_rules" {
    description = "List of ingress rules of the security group"
    type        = list(object({
            from_port        = number
            to_port          = number
            protocol         = string
            cidr_blocks      = list(string)
            ipv6_cidr_blocks = list(string)
            security_groups  = list(string)
    }
    ))
}