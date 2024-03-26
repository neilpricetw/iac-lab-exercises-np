resource "aws_ecr_repository" "api" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = format("%s-ecr", var.prefix)
  }  
}