module "ecs" {
  source          = "../ecs"

  security_groups   = "${var.security_groups}"
  subnets           = "${var.subnets}"
  target_group_arn  = "${var.target_group_arn}"
  load_balancer_arn = "${var.load_balancer_arn}"

  cluster_id        = "${var.ecs_cluster_id}"
  cluster_name      = "${var.ecs_cluster_name}"
  name              = "${var.ecs_service_name}"
  desired_count     = "${var.autoscaling_min_instances}"
  task_image        = "${var.ecs_task_image}"
  task_port         = "${var.ecs_task_port}"
  compute_cpu       = "${var.ecs_compute_cpu}"
  compute_memory    = "${var.ecs_compute_memory}"
}

module "autoscaling" {
  source = "../autoscaling"

  role_arn = "${aws_iam_role.ast_role.arn}"
  service_namespace = "ecs"
  resource_id = "${module.ecs.resource_id}"

  cloudwatch_namespace = "AWS/ECS"
  cloudwatch_dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.ecs_service_name}"
  }

  scalable_dimension = "ecs:service:DesiredCount"
  scale_min = "${var.autoscaling_min_instances}"
  scale_max = "${var.autoscaling_max_instances}"

  threshold_metric = "CPUUtilization"
  threshold_low = "${var.autoscaling_cpu_low_threshold}"
  threshold_high = "${var.autoscaling_cpu_high_threshold}"
}

resource "aws_iam_role" "ast_role" {
  name = "ecsAutoscaleRole"
  assume_role_policy = "${data.aws_iam_policy_document.ast_assume_role_policy.json}"
}

data "aws_iam_policy_document" "ast_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "ast_role_policy" {
  name   = "ecsExecutionRolePolicy"
  role = "${aws_iam_role.ast_role.id}"
  policy = "${data.aws_iam_policy_document.ast_policy.json}"
}

data "aws_iam_policy_document" "ast_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]
  }
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm"
    ]
  }
}
