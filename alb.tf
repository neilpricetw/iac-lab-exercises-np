resource "aws_lb" "alb" {
  name               = format("%s-alb", var.prefix)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name = format("%s-alb", var.prefix)
  }
}

resource "aws_lb_target_group" "tg" {
  name        = format("%s-tg", var.prefix)
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200,302"
        path                = "/users"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }    
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = format("%s-lb-sg", var.prefix)
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

    ingress {
  cidr_blocks         = ["0.0.0.0/0"]
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
   }

    ingress {
  self         = true
  from_port         = 8000
  protocol       = "tcp"
  to_port           = 8000
   }  

   egress {
  cidr_blocks        = ["0.0.0.0/0"]
  from_port         = 0
  protocol       = "-1"
  to_port           = 0  
   }      
}
