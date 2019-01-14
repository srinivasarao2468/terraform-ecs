#-------- Jenkins master variables

variable "key_name" {
  description = ""
  default     = "tf_key"
}

variable "public_key_path" {
  description = ""
  default     = ""
}

variable "jenkins_master_count" {
  description = ""
  default     = 1
}

variable "instance_type" {
  description = ""
  default     = "t2.micro"
}

variable "jenkins_slave_count" {
  description = ""
  default     = 0
}

variable "subnet_ips" {
  description = ""
  type        = "list"
  default     = []
}

variable "vpc_id" {
  description = ""
  default     = ""
}

variable "subnets" {
  description = ""
  type        = "list"
  default     = []
}
