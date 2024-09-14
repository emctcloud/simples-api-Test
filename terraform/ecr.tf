resource "aws_ecr_repository" "this" {
  name                 = "aws-ecr-repo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_repo
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "5 Images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

resource "null_resource" "build_and_push" {
  depends_on = [aws_ecr_repository.this]

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 017820680023.dkr.ecr.us-east-1.amazonaws.com"
  }
  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker build -t aws-ecr-repo ."
  }
  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker tag aws-ecr-repo ${aws_ecr_repository.this.repository_url}:${random_id.version.id}"
  }
  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker push ${aws_ecr_repository.this.repository_url}:${random_id.version.id}"
  }
  triggers = {
    hash = local.service_file_hash
  }
}

