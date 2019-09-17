resource "aws_alb_listener" "main" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${var.target_group_arn}"
    type             = "forward"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.desired_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${var.security_groups}"]
    subnets         = "${var.subnets}"
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "app"
    container_port   = "${var.task_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  depends_on = [
    "aws_alb_listener.main"
  ]
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.compute_cpu}"
  memory                   = "${var.compute_memory}"
  task_role_arn            = "${aws_iam_role.ecs_task_definition_role.arn}"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.compute_cpu},
    "image": "${var.task_image}",
    "memory": ${var.compute_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.task_port},
        "hostPort": ${var.task_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_iam_role" "ecs_task_definition_role" {
  name = "ecsTaskDefinitionRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_assume_role_policy.json}"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_assume_role_policy.json}"
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "ecs_exec" {
  name   = "ecsExecutionRolePolicy"
  role = "${aws_iam_role.ecs_task_execution_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_exec_policy.json}"
}

data "aws_iam_policy_document" "ecs_exec_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}
