# --- ALB ---

data "aws_acm_certificate" "amazon_issued" {
  domain      = "${var.domain}"
  types       = ["AMAZON_ISSUED"] // Change if your certificate has not been issued by AMAZON
  most_recent = true
}

resource "aws_security_group" "http" {
  name_prefix = "http-sg-"
  description = "Allow all HTTP/HTTPS traffic from public"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "marble-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.http.id]
}

resource "aws_lb_target_group" "app" {
  name_prefix = "app-"
  vpc_id      = aws_vpc.main.id
  protocol    = "HTTP"
  port        = 3000
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/healthcheck"
    matcher             = 200
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "api" {
  name_prefix = "api-"
  vpc_id      = aws_vpc.main.id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/liveness"
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
 resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.id
  }
}

# Forward action

resource "aws_lb_listener_rule" "app" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${local.environment.frontend.domain}"]
    }
  }

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.app]
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    host_header {
      values = ["${local.environment.backend.domain}"]
    }
  }

   lifecycle {
    replace_triggered_by = [aws_lb_target_group.api]
  }
}

output "alb_url" {
  value = aws_lb.main.dns_name
}
