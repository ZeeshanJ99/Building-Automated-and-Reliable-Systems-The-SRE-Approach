variable "k8_ami_id" {
    default = "ami-01312800c54282966"
}

variable "public_subnet_cidr" {
    default = "10.102.1.0/24"
}

variable "private_subnet_cidr" {
    default = "10.102.2.0/24"
}

variable "aws_key_name" {
    default = "kieron_kube"
}

variable "aws_key_path" {
    default = "~/.ssh/kieron_kube.pem"
}

variable "k8_sg" {
    default = "sg-01cef38cd22b194b2"
  
}

variable "k8_instance_id" {
    default = "i-02e4257295fd9e915"
  
}