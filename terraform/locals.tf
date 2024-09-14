locals {
  tags = {
    Project      = "AWS-ECS"
    Organization = "KXC"
  }

  # Ajuste na referência da variável e uso de funções
  service_file_hash = sha1(
    join(
      "",
      [
        for file in fileset(var.app_folder, "**") : filesha1("${var.app_folder}/${file}")
      ]
    )
  )
}