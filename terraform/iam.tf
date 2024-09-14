# Documento de política para o papel de execução de tarefas
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Papel para execução de tarefas ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "iam_role_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# Anexar a política AmazonECSTaskExecutionRolePolicy ao papel de execução de tarefas
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Documento de política para o papel de tarefas
data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Papel para tarefas ECS
resource "aws_iam_role" "ecs_task_role" {
  name               = "iam_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume_policy.json
}

# Adicionar permissões específicas para o papel de tarefas ECS
data "aws_iam_policy_document" "ecs_task_role_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

# Anexar a política personalizada ao papel de tarefas
resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = "ecs_task_role_policy"
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}
