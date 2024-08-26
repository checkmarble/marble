# --- ECS Node SG ---

resource "aws_security_group" "ecs_node_sg" {
  name_prefix = "marble-ecs-node-sg-"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [ aws_security_group.http.id ]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}