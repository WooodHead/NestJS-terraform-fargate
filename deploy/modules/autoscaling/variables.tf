variable "service_namespace" {
    description = "Namespace for the target resource"
}

variable "resource_id" {
    description = "The resource_id of the autoscaling target"
}

variable "role_arn" {

}

variable "scale_max" {
  description = "Maximum number of resources"
}
variable "scale_min" {
  description = "Minimum number of resources"
}
variable "scalable_dimension" {
  description = "Dimension to be scaled by autoscaling"
}

variable "cloudwatch_namespace" {
  description = "Namespace of target service to be processed by cloudwatch"
}

variable "cloudwatch_dimensions" {
  description = "Dimensions to be processed by cloudwatch"
}

variable "threshold_metric" {
  description = "Metric used to evaluate utilization"
}

variable "threshold_high" {
  description = "High utilization threshold"
}

variable "threshold_low" {
  description = "Low utilization threshold"
}