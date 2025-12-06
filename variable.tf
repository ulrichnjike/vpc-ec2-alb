variable "ENVIRONMENT" {
  description = "this is ec2 name"
  default   = "dev-ec2"
  type      = string
  
}

variable "REGION" {
  description = "This is aws region"
  type        = string
  default     = "us-east-1"
  
}

variable "INSTANCE_TYPE" {
  description = "This is aws ec2 type "
  default = "t2.medium"
  type        = string  
  
}