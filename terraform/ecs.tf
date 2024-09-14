resource "aws_ecs_cluster" "this" {
  name = "aws-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "task_definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.ecs.fargate_cpu
  memory                   = var.ecs.fargate_memory
  container_definitions = jsonencode([{
    name      = "aws-ecs-container"
    image     = "${aws_ecr_repository.this.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_service" "this" {
  name                               = "ecs-service"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 2
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"
  health_check_grace_period_seconds  = 10
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_alb_listener.http, aws_iam_role.ecs_task_execution_role]

  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name   = "aws-ecs-container"
    container_port   = 3000
  }
  network_configuration {
    subnets          = [aws_subnet.ecs_sub_priv_1a.id, aws_subnet.ecs_sub_priv_1b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}