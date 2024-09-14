resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/aws-ecs"
  retention_in_days = 1
}