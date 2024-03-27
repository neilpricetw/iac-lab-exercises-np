resource "aws_ecr_repository" "api" {
  name                 = format("%s-crud-app", var.prefix)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true  

  tags = {
    Name = format("%s-ecr", var.prefix)
  }  
}