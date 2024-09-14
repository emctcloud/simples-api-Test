resource "aws_alb" "this" {
  name            = "aws-ecs-alb"
  subnets         = [aws_subnet.ecs_sub_pub_1a.id, aws_subnet.ecs_sub_pub_1b.id]
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "this" {
  vpc_id      = aws_vpc.ecs-vpc.id
  name        = "aws-ecs-albTarget"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    unhealthy_threshold = "2"
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }
}