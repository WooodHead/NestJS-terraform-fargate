variable "subnets" {

}

variable "security_groups" {
  
}
variable "cluster_id" {
  description = "Id of the ECS Cluster it belongs to"
}

variable "cluster_name" {
  description = "Name of the ECS Cluster it belongs to"
}

variable "name" {
  description = "Name of the ECS Service"
}

variable "desired_count" {
  description = "Number of docker containers to run"
}

variable "task_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "task_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "compute_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}
variable "compute_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "target_group_arn" {
  description = "Target Group ARN to point to ECS"
}

variable "load_balancer_arn" {

}
