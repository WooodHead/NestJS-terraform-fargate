resource "aws_appautoscaling_target" "main" {
  role_arn           = "${var.role_arn}"

  service_namespace  = "${var.service_namespace}"
  resource_id        = "${var.resource_id}"

  scalable_dimension = "${var.scalable_dimension}"
  max_capacity       = "${var.scale_max}"
  min_capacity       = "${var.scale_min}"
}

resource "aws_cloudwatch_metric_alarm" "high" {
  alarm_name          = "${var.resource_id}-${var.threshold_metric}-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "${var.cloudwatch_namespace}"
  metric_name         = "${var.threshold_metric}"
  threshold           = "${var.threshold_high}"
  period              = "60"
  statistic           = "Average"

  dimensions = "${var.cloudwatch_dimensions}"
  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
}

resource "aws_appautoscaling_policy" "up" {
  name               = "${var.resource_id}-scale-up"
  service_namespace  = "${aws_appautoscaling_target.main.service_namespace}"
  resource_id        = "${aws_appautoscaling_target.main.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.main.scalable_dimension}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "low" {
  alarm_name          = "${var.resource_id}-${var.threshold_metric}-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  namespace           = "${var.cloudwatch_namespace}"
  metric_name         = "${var.threshold_metric}"
  threshold           = "${var.threshold_low}"
  period              = "60"
  statistic           = "Average"

  dimensions = "${var.cloudwatch_dimensions}"
  alarm_actions = ["${aws_appautoscaling_policy.down.arn}"]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "${var.resource_id}-scale-down"
  service_namespace  = "${aws_appautoscaling_target.main.service_namespace}"
  resource_id        = "${aws_appautoscaling_target.main.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.main.scalable_dimension}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}