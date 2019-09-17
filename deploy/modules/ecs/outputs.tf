output "resource_id" {
    value = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
}