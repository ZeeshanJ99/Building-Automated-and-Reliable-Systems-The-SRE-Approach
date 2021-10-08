variable "k8_ami_id" {
    default = "ami-0761652f883da97e0"
}

variable "public_subnet_cidr" {
    default = "10.102.1.0/24"
}

variable "private_subnet_cidr" {
    default = "10.102.2.0/24"
}

variable "instance_type" {
    default = "t2.medium"
}

variable "aws_key_name" {
    default = "kieron_kube"
}

variable "aws_key_path" {
    default = "~/.ssh/kieron_kube.pem"
}

variable "k8_instance_id" {
    default = "i-02e4257295fd9e915"
}

variable "vpc_cidr" {
    default = "10.102.0.0/16"
}
