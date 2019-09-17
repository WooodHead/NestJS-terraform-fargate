variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  default = "gautasaur"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_name" {
  description = "Name of the application"
  default = "app"
}