resource "aws_security_group" "alb" {
  name        = "SecurityGroup-ALG"
  description = "Controle de Acesso ALB"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "SecurityGroup-ECS-Tasks"
  description = "Allow inbound access from the ALB"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    from_port       = var.ecs.app_port
    to_port         = var.ecs.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Ecs-Tasks"
  }
}