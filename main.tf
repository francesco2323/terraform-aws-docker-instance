data "aws_ami" "amazon-linux-2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "aws_vpc" "default" {
  count   = var.create_security_group && var.vpc_id == null ? 1 : 0
  default = true
}

locals {
  effective_vpc_id   = var.vpc_id != null ? var.vpc_id : try(data.aws_vpc.default[0].id, null)
  security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : [var.security_group_id]
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon-linux-2023.id
  instance_type               = var.instance_type
  count                       = var.instance_count
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = local.security_group_ids
  user_data                   = templatefile("${abspath(path.module)}/userdata.sh", { myserver = var.server_name })

  tags = merge(var.common_tags, {
    Name = var.name
  })
}

resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.name}-terraform-sec-grp"
  description = "Security group for Docker EC2 instances"
  vpc_id      = local.effective_vpc_id

  tags = merge(var.common_tags, {
    Name = var.name
  })

  dynamic "ingress" {
    for_each = var.ingress_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}