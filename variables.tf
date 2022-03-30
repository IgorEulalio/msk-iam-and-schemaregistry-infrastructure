variable "msk_broker_instance_type" {
  description = "Instance type for MSK broker"
  type        = string
  default     = "kafka.m5.large"
}

variable "vpc_id" {
  description = "Id of the VPC for MSK broker be launched"
  type        = string
  default     = "vpc-default"
}

variable "ebs_volume_size" {
  description = "Size of EBS Volume for MSK broker instances"
  type        = number
  default     = "100"
}

variable "subnet_az1_id" {
  description = "Subnet id for AZ1"
  type        = string
  default     = "subnet-xxxxxxx"
}

variable "subnet_az2_id" {
  description = "Subnet id for AZ2"
  type        = string
  default     = "subnet-yyyyyyy"
}

variable "subnet_az3_id" {
  description = "Subnet id for AZ3"
  type        = string
  default     = "subnet-zzzzzzz"
}



