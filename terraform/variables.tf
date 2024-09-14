variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type        = string
  description = "CIDR Block"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "allowed_ip" {
  description = "IP/CIDR"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair"
  type        = string
}

variable "app_folder" {
  description = "Local App Folder"
  type        = string
  default     = "../"
}

variable "force_delete_repo" {
  description = "Deleted Image"
  type        = bool
  default     = true
}

variable "ecs" {
  description = "ECS Service"
  type = object({
    fargate_cpu       = number
    fargate_memory    = number
    app_port          = number
    app_count         = number
    app_image         = string
    health_check_path = string
  })
  default = {
    fargate_cpu       = 256
    fargate_memory    = 512
    app_port          = 3000
    app_count         = 1
    app_image         = "" # Atualizar após criação do repositório
    health_check_path = "/"
  }
}

variable "log_level" {
  description = "Logging level"
  type        = string
  default     = "debug"
}
