# --- ECS ASG ---

resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "marble-ecs-asg-"
  vpc_zone_identifier       = aws_subnet.public[*].id
  min_size                  = 2
  max_size                  = 5
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false
  
  # Rotation automatique : les instances seront remplacées après 7 jours
  max_instance_lifetime     = 86400  # 7 jours en secondes (ou 86400 pour 1 jour)

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "marble-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  # Configuration pour un refresh contrôlé des instances
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50  # Au moins 50% des instances restent up pendant le refresh
      instance_warmup        = 60  # Temps d'attente après démarrage d'une nouvelle instance
    }
  }
}
