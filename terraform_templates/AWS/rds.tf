# https://www.terraform.io/docs/providers/aws/r/db_instance.html

resource "random_string" "rds-db-password" {
  length  = 32
  upper   = true
  special = false
}


resource "aws_db_parameter_group" "pg-marble" {
  name   = "pg-marble"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "rds_marble_monitoring_role" {
  name = "rds-marble-monitoring-role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }
  ]
})
}

resource "aws_iam_policy_attachment" "rds_monitoring_attachment" {
  name = "rds-monitoring-attachment"
  roles = [aws_iam_role.rds_marble_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "rds" {
  vpc_id      = aws_vpc.main.id
  name        = "rds-sg"
  description = "Allow inbound for Postgres from EC2 SG"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [ aws_security_group.ecs_node_sg.id ]
  }
}

resource "aws_db_subnet_group" "marble_rds_subnet_group" {
  name = "marble_rds_subnet_group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "Marble DB Subnet Group"
  }
}

resource "aws_db_instance" "rds-marble" {
    
  identifier             = "rds-marble-${terraform.workspace}"
  name                   = "marble"
  instance_class         = "db.t4g.small"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "15"
  publicly_accessible    = true
  allow_major_version_upgrade = true
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name = aws_db_subnet_group.marble_rds_subnet_group.name
  parameter_group_name = aws_db_parameter_group.pg-marble.name

  username               = "postgres"
  password               = random_string.rds-db-password.result

  skip_final_snapshot = false
  final_snapshot_identifier = "db-marble-snap"
  
  # Backup retention period (in days)   
  backup_retention_period = 7

  multi_az = true

  # Enable enhanced monitoring
  monitoring_interval = 60 # Interval in seconds (minimum 60 seconds)
  monitoring_role_arn = aws_iam_role.rds_marble_monitoring_role.arn

  # Enable performance insights
  performance_insights_enabled = true
}


output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds-marble.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds-marble.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.rds-marble.username
  sensitive   = true
}