resource "aws_sns_topic" "ecs_events" {
  name = "ecs_events_${var.environment}_${var.cluster}"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  current = true
}

data "template_file" "ecs_task_stopped" {
  template = ${file("${path.module}/templates/ecs_task_stopped.tpl")}

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
    cluster    = "${var.cluster}"
    aws_region = "${data.aws_region.current.name}"
  }
}

resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
  name          = "${var.environment}_${var.cluster}_task_stopped"
  description   = "${var.environment}_${var.cluster} Essential container in task exited"
  event_pattern = "${data.template_file.ecs_task_stopped.rendered}"
}

resource "aws_cloudwatch_event_target" "event_fired" {
  rule  = "${aws_cloudwatch_event_rule.ecs_task_stopped.name}"
  arn   = "${aws_sns_topic.ecs_events.arn}"
  input = "{ \"message\": \"Essential container in task exited\", \"account_id\": \"${data.aws_caller_identity.current.account_id}\", \"cluster\": \"${var.cluster}\"}"
}
