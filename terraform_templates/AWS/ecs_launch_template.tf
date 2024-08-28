# --- ECS Launch Template ---

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "marble-ecs-ec2-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.ecs_node_sg.id]
  key_name =  var.aws_key_pair

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  update_default_version = true

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config;
      echo '${file("config/credentials.json")}' >> /tmp/credentials.json;
    EOF
  )
}