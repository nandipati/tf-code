resource "aws_appautoscaling_policy" "dynamodb_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "dynamodb_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "dynamodb_read_target" {
  max_capacity       = "${var.max_read_capacity}"
  min_capacity       = "${var.min_read_capacity}"
  resource_id        = "${var.resource_id}"
  scalable_dimension = "dynamodb:${var.scalable_dimension_type}:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_write_target" {
  max_capacity       = "${var.max_write_capacity}"
  min_capacity       = "${var.min_write_capacity}"
  resource_id        = "${var.resource_id}"
  scalable_dimension = "dynamodb:${var.scalable_dimension_type}:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}
